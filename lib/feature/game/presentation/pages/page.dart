import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/presentation/pages/loading_page.dart';
import '../bloc/game/game_bloc.dart';
import 'game_manual_page.dart';
import 'game_stats_page.dart';
import 'game_worker_page.dart';

///
class GamePage extends StatelessWidget {
  /// Determines if game should be run as worker or manual.
  final bool asWorker;

  /// Uid of the game.
  final String gameUid;

  /// Uid of the player.
  final String playerUid;

  ///
  GamePage({
    Key key,
    this.asWorker = false,
    @required this.gameUid,
    @required this.playerUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc()
        ..add(asWorker ? GameEvent.toWorker() : GameEvent.toManual()),
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          return state.when(
            initial: () => RaisedButton(
              onPressed: () {
                BlocProvider.of<GameBloc>(context).add(
                    asWorker ? GameEvent.toWorker() : GameEvent.toManual());
              },
              child: LoadingPage(),
            ),
            worker: () => GameWorkerPage(
              gameUid: gameUid,
              playerUid: playerUid,
            ),
            manual: () => GameManualPage(
              gameUid: gameUid,
              playerUid: playerUid,
            ),
            stats: () => GameStatsPage(
              gameUid: gameUid,
              playerUid: playerUid,
            ),
          );
        },
      ),
    );
  }
}
