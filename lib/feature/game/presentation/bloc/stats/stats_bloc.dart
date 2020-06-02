import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/game.dart';
import '../../../domain/usecases/connect_to_game.dart';
import '../../../domain/usecases/save_game.dart';

part 'stats_bloc.freezed.dart';
part 'stats_event.dart';
part 'stats_state.dart';

/// {@template stats_bloc}
///
/// {@endtemplate}
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  ///
  final String gameUid;

  ///
  final String playerUid;

  ///
  final ConnectToGame connectToGame;

  ///
  final SaveGame saveGame;

  final _subscribtions = <StreamSubscription>[];

  /// {@macro game_bloc}
  StatsBloc({
    @required this.gameUid,
    @required this.playerUid,
    @required this.connectToGame,
    @required this.saveGame,
  });

  @override
  StatsState get initialState => StatsState.initial();

  @override
  Future<void> close() async {
    for (final subscribtion in _subscribtions) {
      subscribtion.cancel();
    }

    super.close();
  }

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
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
            add(StatsEvent.update(game: game));
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
      },
      update: (game) async* {
        yield StatsState.data(game: game);
      },
    );
  }
}
