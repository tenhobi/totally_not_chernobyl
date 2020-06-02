import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/presentation/pages/loading_page.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../domain/usecases/connect_to_game.dart';
import '../../domain/usecases/save_game.dart';
import '../bloc/stats/stats_bloc.dart';

///
class GameStatsPage extends StatelessWidget {
  ///
  final String gameUid;

  ///
  final String playerUid;

  final _gameRepository = GameRepositoryImpl();

  ///
  GameStatsPage({
    Key key,
    @required this.gameUid,
    @required this.playerUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsBloc(
        connectToGame: ConnectToGame(_gameRepository),
        gameUid: gameUid,
        playerUid: playerUid,
        saveGame: SaveGame(_gameRepository),
      )..add(StatsEvent.connect()),
      child: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          return state.when(
            initial: () => LoadingPage(),
            data: (game) {
              String note;

              if (game.boom == true) {
                note = tr('text_exploded');
              } else if (game.endTime == null) {
                note = tr('text_early-termination');
              } else {
                note = tr(
                  'text_stats-time-left',
                  args: [
                    game.endTime.toString(),
                    game.time.toString(),
                  ],
                );
              }

              var victory = game.finished &&
                  game.modulesLeft != null &&
                  game.modulesLeft == 0 &&
                  game.endTime != null &&
                  game.endTime <= game.time;

              if (game.boom == true) {
                victory = false;
              }

              return Scaffold(
                appBar: AppBar(
                  title: Text(game.missionName),
                  centerTitle: true,
                ),
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      Text(
                        victory
                            ? tr('text_stats-win')
                            : tr('text_stats-defeat'),
                        style: TextStyle(
                          fontSize: 36,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Text(note),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
