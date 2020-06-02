import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../shared/domain/entities/lobby.dart';
import '../../../../../shared/domain/usecases/get_user_by_uid.dart';
import '../../../domain/usecases/connect_to_lobby.dart';
import '../../../domain/usecases/get_mission.dart';
import '../../../domain/usecases/update_lobby.dart';

part 'connected_bloc.freezed.dart';
part 'connected_event.dart';
part 'connected_state.dart';

/// {@template connected_bloc}
/// Determines functionality of [Lobby] connected user.
/// {@endtemplate}
class ConnectedBloc extends Bloc<ConnectedEvent, ConnectedState> {
  /// Player uid.
  final String playerUid;

  /// Usecase.
  final UpdateLobby updateLobby;

  /// Usecase.
  final GetUserByUid getUserByUid;

  /// Usecase.
  final ConnectToLobby connectToLobby;

  /// Usecase.
  final GetMission getMission;

  /// {@macro connected_bloc}
  ConnectedBloc({
    @required this.playerUid,
    @required this.updateLobby,
    @required this.getUserByUid,
    @required this.connectToLobby,
    @required this.getMission,
  });

  final _subscribtions = <StreamSubscription>[];

  @override
  ConnectedState get initialState => ConnectedState.initial();

  @override
  Stream<ConnectedState> mapEventToState(ConnectedEvent event) async* {
    yield* event.when(
      connect: (
        roomUid,
        playerUid,
      ) async* {
        final subscribtion = connectToLobby(
          ConnectToLobbyParams(
            roomUid: roomUid,
            joinedUid: playerUid,
          ),
        ).listen((lobbyEither) {
          lobbyEither.fold((l) {
            print("error connect lobby");
          }, (lobby) {
            add(ConnectedEvent.update(lobby: lobby));
          });
        });

        _subscribtions.add(subscribtion);
      },
      update: (lobby) async* {
        await updateLobby(
            UpdateLobbyParams(roomUid: lobby.roomId, lobby: lobby));

        String otherPlayerName;

        if (lobby.joinedUid != null) {
          final otherUser =
              await getUserByUid(GetUserByUidParams(uid: lobby.creatorUid));

          otherUser.fold((l) => null, (user) {
            otherPlayerName = user.username;
          });
        }

        String missionName;

        final mission = await getMission(GetMissionParams(
          chapterUid: lobby.chapterUid,
          missionUid: lobby.missionUid,
        ));

        mission.fold((l) => null, (r) => missionName = r.missionName);

        yield ConnectedState.data(
          lobby: lobby,
          otherPlayerName: otherPlayerName,
          missionName: missionName,
        );
      },
    );
  }

  @override
  Future<void> close() async {
    for (final subscribtion in _subscribtions) {
      subscribtion.cancel();
    }

    super.close();
  }
}
