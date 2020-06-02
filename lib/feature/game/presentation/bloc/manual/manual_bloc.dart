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

part 'manual_bloc.freezed.dart';
part 'manual_event.dart';
part 'manual_state.dart';

///
class ManualBloc extends Bloc<ManualEvent, ManualState> {
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

  final _modules = <GameModule>[];

  final _subscribtions = <StreamSubscription>[];

  final _actions = <GameAction>[];

  /// {@macro game_bloc}
  ManualBloc({
    @required this.gameUid,
    @required this.playerUid,
    @required this.connectToGame,
    @required this.saveGame,
    @required this.fetchModules,
    @required this.fetchActions,
  });

  @override
  ManualState get initialState => ManualState.initial();

  @override
  Future<void> close() async {
    for (final subscribtion in _subscribtions) {
      subscribtion.cancel();
    }

    super.close();
  }

  @override
  Stream<ManualState> mapEventToState(ManualEvent event) async* {
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
            add(ManualEvent.update(game: game));
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

        add(ManualEvent.update(game: game));
      },
      update: (game) async* {
        if (_modules.length == 0) {
          final result = await fetchModules(FetchModulesParams(game: game));

          // ignore: unnecessary_lambdas
          result.fold((l) {}, (r) {
            _modules.addAll(r);
          });

          final actions = await fetchActions(FetchActionsParams(game: game));

          // ignore: unnecessary_lambdas
          actions.fold((l) {}, (r) {
            _actions.addAll(r);
          });
        }

        yield ManualState.data(
            game: game, modules: _modules, actions: _actions);
      },
    );
  }
}
