import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/data/repositories/user_repository_impl.dart';
import '../../../../shared/domain/usecases/get_user_by_uid.dart';
import '../../../game/presentation/pages/page.dart';
import '../../../home/presentation/bloc/authentication/authentication_bloc.dart';
import '../../data/repositories/lobby_repository_impl.dart';
import '../../domain/usecases/connect_to_lobby.dart';
import '../../domain/usecases/get_mission.dart';
import '../../domain/usecases/update_lobby.dart';
import '../bloc/connected/connected_bloc.dart';

///
class ConnectedGamePage extends StatefulWidget {
  /// Room uid.
  final String roomUid;

  ///
  ConnectedGamePage({
    Key key,
    @required this.roomUid,
  }) : super(key: key);

  @override
  _ConnectedGamePageState createState() => _ConnectedGamePageState();
}

class _ConnectedGamePageState extends State<ConnectedGamePage> {
  final _lobbyRepository = LobbyRepositoryImpl();

  final _userRepository = UserRepositoryImpl();

  String _lastGameUid;

  @override
  Widget build(BuildContext context) {
    String playerUid;
    BlocProvider.of<AuthenticationBloc>(context).state.maybeWhen(
          authenticated: (uid) => playerUid = uid,
          orElse: () {},
        );

    return BlocProvider(
      create: (context) => ConnectedBloc(
        playerUid: playerUid,
        updateLobby: UpdateLobby(_lobbyRepository),
        getUserByUid: GetUserByUid(_userRepository),
        connectToLobby: ConnectToLobby(_lobbyRepository),
        getMission: GetMission(_lobbyRepository),
      )..add(ConnectedEvent.connect(
          roomUid: widget.roomUid,
          playerUid: playerUid,
        )),
      child: BlocConsumer<ConnectedBloc, ConnectedState>(
        listener: (context, state) {
          state.when(
            initial: null,
            data: (lobby, otherPlayerName, missionName) {
              if (lobby.gameUid != null && _lastGameUid != lobby.gameUid) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return GamePage(
                        asWorker: lobby.workerUid == playerUid,
                        gameUid: lobby.gameUid,
                        playerUid: playerUid,
                      );
                    },
                  ),
                );

                setState(() {
                  _lastGameUid = lobby.gameUid;
                });
              }
            },
          );
        },
        builder: (context, state) {
          return state.when<Widget>(
            initial: () => Container(),
            data: (lobby, otherPlayerName, missionName) {
              var readyCount = 0;
              if (lobby.creatorReady) readyCount++;
              if (lobby.joinedReady) readyCount++;

              return Scaffold(
                appBar: AppBar(
                  title: Text(tr('title_lobby')),
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('$readyCount/2'),
                        RaisedButton(
                          child: Text(tr('btn_game-ready')),
                          onPressed: (lobby.joinedReady != true)
                              ? () {
                                  BlocProvider.of<ConnectedBloc>(context).add(
                                    ConnectedEvent.update(
                                      lobby: lobby.copyWith(
                                        joinedReady: true,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Text(tr('text_lobby-with',
                            args: [otherPlayerName ?? '?'])),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Text(tr('text_lobby-mission-selection', args: [
                          missionName ?? '?',
                        ])),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          tr(
                            'text_lobby-you-are-role',
                            args: [
                              lobby.workerUid == null
                                  ? '?'
                                  : lobby.workerUid == playerUid
                                      ? tr('btn_lobby-role-worker')
                                          .toLowerCase()
                                      : tr('btn_lobby-role-manual')
                                          .toLowerCase()
                            ],
                          ),
                        ),
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
