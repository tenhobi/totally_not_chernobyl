import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/random_string.dart';
import '../../../../../shared/domain/entities/lobby.dart';
import '../../../../../shared/domain/usecases/get_user_by_uid.dart';
import '../../../domain/entities/mission.dart';
import '../../../domain/usecases/create_game.dart';
import '../../../domain/usecases/create_lobby.dart';
import '../../../domain/usecases/get_missions.dart';
import '../../../domain/usecases/update_lobby.dart';

part 'created_bloc.freezed.dart';
part 'created_event.dart';
part 'created_state.dart';

/// {@template created_bloc}
/// Determines functionality of [Lobby] owner.
/// {@endtemplate}
class CreatedBloc extends Bloc<CreatedEvent, CreatedState> {
  /// Player uid.
  final String playerUid;

  /// Usecase.
  final CreateLobby createLobby;

  /// Usecase.
  final UpdateLobby updateLobby;

  /// Usecase.
  final GetUserByUid getUserByUid;

  /// Usecase.
  final GetMissions getMissions;

  /// Usecase.
  final CreateGame createGame;

  final _subscribtions = <StreamSubscription>[];

  /// {@macro created_bloc}
  CreatedBloc({
    @required this.playerUid,
    @required this.createLobby,
    @required this.updateLobby,
    @required this.getUserByUid,
    @required this.getMissions,
    @required this.createGame,
  });

  @override
  CreatedState get initialState => CreatedState.initial();

  @override
  Future<void> close() async {
    print('close created bloc subscribtions');
    for (final subscribtion in _subscribtions) {
      subscribtion.cancel();
    }

    super.close();
  }

  @override
  Stream<CreatedState> mapEventToState(CreatedEvent event) async* {
    yield* event.when(
      start: (lobby, missionName) async* {
        final game = await createGame(CreateGameParams(
          lobby: lobby,
          missionName: missionName,
        ));

        yield* game.fold((l) async* {}, (r) async* {
          add(CreatedEvent.update(lobby: lobby.copyWith(gameUid: r)));
        });
      },
      create: () async* {
        final subscribtion = createLobby(
          CreateLobbyParams(
            creatorUid: playerUid,
            roomUid: randomString(5),
          ),
        ).listen((lobbyEither) {
          lobbyEither.fold((l) {
            print("error create lobby");
          }, (lobby) {
            add(CreatedEvent.update(lobby: lobby));
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
              await getUserByUid(GetUserByUidParams(uid: lobby.joinedUid));

          otherUser.fold((l) => null, (user) {
            otherPlayerName = user.username;
          });
        }

        List<Mission> missionsList;

        final missions = await getMissions(NoParams());
        missions.fold((l) => null, (r) => missionsList = r);

        yield CreatedState.data(
          lobby: lobby,
          otherPlayerName: otherPlayerName,
          missions: missionsList,
        );
      },
    );
  }
}
