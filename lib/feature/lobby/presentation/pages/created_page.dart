import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/data/repositories/user_repository_impl.dart';
import '../../../../shared/domain/usecases/get_user_by_uid.dart';
import '../../../game/presentation/pages/page.dart';
import '../../../home/presentation/bloc/authentication/authentication_bloc.dart';
import '../../data/repositories/lobby_repository_impl.dart';
import '../../domain/entities/mission.dart';
import '../../domain/usecases/create_game.dart';
import '../../domain/usecases/create_lobby.dart';
import '../../domain/usecases/get_missions.dart';
import '../../domain/usecases/update_lobby.dart';
import '../bloc/created/created_bloc.dart';

///
class CreatedGamePage extends StatefulWidget {
  @override
  _CreatedGamePageState createState() => _CreatedGamePageState();
}

class _CreatedGamePageState extends State<CreatedGamePage> {
  final _lobbyRepository = LobbyRepositoryImpl();
  final _userRepository = UserRepositoryImpl();

  Mission missionValue;

  String _lastGameUid;

  @override
  Widget build(BuildContext context) {
    String playerUid;
    BlocProvider.of<AuthenticationBloc>(context).state.maybeWhen(
          authenticated: (uid) => playerUid = uid,
          orElse: () {},
        );

    return BlocProvider(
      create: (context) => CreatedBloc(
        playerUid: playerUid,
        createLobby: CreateLobby(_lobbyRepository),
        updateLobby: UpdateLobby(_lobbyRepository),
        getUserByUid: GetUserByUid(_userRepository),
        getMissions: GetMissions(_lobbyRepository),
        createGame: CreateGame(_lobbyRepository),
      )..add(CreatedEvent.create()),
      child: BlocConsumer<CreatedBloc, CreatedState>(
        listener: (context, state) {
          state.when(
            initial: () {},
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
            data: (lobby, otherPlayerName, missions) {
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
                          onPressed: (lobby.creatorReady != true)
                              ? () {
                                  BlocProvider.of<CreatedBloc>(context).add(
                                    CreatedEvent.update(
                                      lobby: lobby.copyWith(
                                        creatorReady: true,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                        ),
                        RaisedButton(
                          child: Text(tr('btn_game-start')),
                          onPressed: (lobby.creatorReady == true &&
                                  lobby.joinedReady == true &&
                                  lobby.gameUid == null &&
                                  lobby.missionUid != null &&
                                  lobby.workerUid != null)
                              ? () {
                                  BlocProvider.of<CreatedBloc>(context).add(
                                    CreatedEvent.start(
                                      lobby: lobby,
                                      missionName: missionValue.missionName,
                                    ),
                                  );
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Text(tr('text_lobby-key', args: [lobby.roomId])),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Text(tr('text_lobby-with',
                          args: [otherPlayerName ?? '?'])),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Text(tr('text_lobby-role')),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(tr('btn_lobby-role-worker')),
                          color:
                              lobby.workerUid == playerUid ? Colors.blue : null,
                          onPressed: (lobby.joinedUid == null)
                              ? null
                              : () {
                                  BlocProvider.of<CreatedBloc>(context).add(
                                    CreatedEvent.update(
                                      lobby: lobby.copyWith(
                                          workerUid: lobby.creatorUid),
                                    ),
                                  );
                                },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        RaisedButton(
                          child: Text(tr('btn_lobby-role-manual')),
                          color: (lobby.workerUid == playerUid ||
                                  lobby.workerUid == null)
                              ? null
                              : Colors.blue,
                          onPressed: (lobby.joinedUid == null)
                              ? null
                              : () {
                                  BlocProvider.of<CreatedBloc>(context).add(
                                    CreatedEvent.update(
                                      lobby: lobby.copyWith(
                                          workerUid: lobby.joinedUid),
                                    ),
                                  );
                                },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Text(tr('text_lobby-mission')),
                    ),
                    Container(
                      width: 200,
                      child: DropdownButtonFormField<Mission>(
                        decoration: InputDecoration(
                          labelText: tr('text_lobby-mission'),
                        ),
                        items: [
                          for (final mission in missions)
                            DropdownMenuItem<Mission>(
                              value: mission,
                              child: Text(mission.missionName),
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            missionValue = Mission(
                              chapterUid: value.chapterUid,
                              missionUid: value.missionUid,
                              missionName: value.missionName,
                            );
                          });

                          BlocProvider.of<CreatedBloc>(context).add(
                            CreatedEvent.update(
                              lobby: lobby.copyWith(
                                chapterUid: value.chapterUid,
                                missionUid: value.missionUid,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
