import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/lobby_repository_impl.dart';
import '../../domain/usecases/can_connect_to_lobby.dart';
import '../bloc/lobby/lobby_bloc.dart';
import 'connected_game_page.dart';
import 'created_page.dart';
import 'join_game_page.dart';

///
class LobbyPage extends StatelessWidget {
  ///
  final bool isGameCreated;

  final _lobbyRepository = LobbyRepositoryImpl();

  ///
  LobbyPage({
    Key key,
    this.isGameCreated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LobbyBloc(
        canConnectToLobby: CanConnectToLobby(_lobbyRepository),
      )..add(isGameCreated ? LobbyEvent.create() : LobbyEvent.join()),
      child: BlocBuilder<LobbyBloc, LobbyState>(
        builder: (context, state) {
          return state.when(
            initial: () => Center(
              child: Text('Initial 1'),
            ),
            created: () => CreatedGamePage(),
            joining: (failed) => JoinGamePage(
              failed: failed,
            ),
            connected: (roomUid) => ConnectedGamePage(
              roomUid: roomUid,
            ),
          );
        },
      ),
    );
  }
}
