import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/game.dart';
import '../../../domain/entities/game_action.dart';
import '../../../domain/entities/game_module.dart';
import '../../../domain/usecases/connect_to_game.dart';
import '../../../domain/usecases/fetch_actions.dart';
import '../../../domain/usecases/fetch_modules.dart';
import '../../../domain/usecases/save_game.dart';

part 'worker_bloc.freezed.dart';
part 'worker_event.dart';
part 'worker_state.dart';

///
class WorkerBloc extends Bloc<WorkerEvent, WorkerState> {
  ///
  final String gameUid;

  ///
  final String playerUid;

  ///
  final ConnectToGame connectToGame;

  ///
  final SaveGame saveGame;

  ///
  final FetchModules fetchModules;

  ///
  final FetchActions fetchActions;

  final _subscribtions = <StreamSubscription>[];

  final _modules = <GameModule>[];

  final _actions = <GameAction>[];

  int _modulesLeft;

  int _errorsLeft;

  /// {@macro game_bloc}
  WorkerBloc({
    @required this.gameUid,
    @required this.playerUid,
    @required this.connectToGame,
    @required this.saveGame,
    @required this.fetchModules,
    @required this.fetchActions,
  });

  @override
  WorkerState get initialState => WorkerState.initial();

  @override
  Future<void> close() async {
    for (final subscribtion in _subscribtions) {
      subscribtion.cancel();
    }

    super.close();
  }

  @override
  Stream<WorkerState> mapEventToState(WorkerEvent event) async* {
    yield* event.when(
      connect: () async* {
        final subscribtion = connectToGame(
          ConnectToGameParams(
            gameUid: gameUid,
          ),
        ).listen((lobbyEither) {
          lobbyEither.fold((l) {
            print("error connect game");
          }, (game) {
            add(WorkerEvent.update(game: game));
          });
        });

        _subscribtions.add(subscribtion);
      },
      save: (game) async* {
        await saveGame(
          SaveGameParams(
            game: game,
            gameUid: gameUid,
          ),
        );

        add(WorkerEvent.update(game: game));
      },
      update: (game) async* {
        if (_modules.length == 0) {
          final result = await fetchModules(FetchModulesParams(game: game));

          // ignore: unnecessary_lambdas
          result.fold((l) {}, (r) {
            _modules.addAll(r);

            _modulesLeft = 0;
            for (var module in r) {
              _modulesLeft += module.times;
            }
          });

          _errorsLeft = game.errors;

          final actions = await fetchActions(FetchActionsParams(game: game));

          // ignore: unnecessary_lambdas
          actions.fold((l) {}, (r) {
            _actions.addAll(r);
          });
        }

        yield WorkerState.data(
          game: game,
          modules: _modules,
          modulesLeft: _modulesLeft,
          errorsLeft: _errorsLeft ?? 0,
          actions: _actions,
        );
      },
      completeModule: () async* {
        _modulesLeft--;

        state.when(
            initial: () {},
            data: (game, modules, modulesLeft, errorsLeft, actions) {
              add(WorkerEvent.update(game: game));
            });
      },
      fail: (total) async* {
        state.when(
          initial: () {},
          data: (game, modules, modulesLeft, errorsLeft, actions) {
            if (total) {
              add(
                WorkerEvent.save(
                  game: game.copyWith(
                    finished: true,
                    boom: true,
                  ),
                ),
              );
            } else {
              if (_errorsLeft == 0) {
                add(
                  WorkerEvent.save(
                    game: game.copyWith(
                      finished: true,
                      boom: true,
                    ),
                  ),
                );
              } else {
                _errorsLeft--;
                add(
                  WorkerEvent.update(game: game),
                );
              }
            }
          },
        );
      },
    );
  }
}
