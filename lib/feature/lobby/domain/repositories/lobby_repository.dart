import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/lobby.dart';
import '../entities/mission.dart';

/// Repository that handles the lobby feature.
abstract class LobbyRepository {
  /// Determines if user can join to game by its [roomUid].
  Future<Either<Failure, bool>> canJoinGame({
    @required String roomUid,
  });

  /// Create Game from Lobby.
  Future<Either<Failure, String>> createGame({
    @required Lobby lobby,
    @required String missionName,
  });

  /// Create [Lobby].
  Future<Either<Failure, bool>> createLobby({
    @required String roomUid,
    @required String creatorUid,
  });

  /// Fetches missions.
  Future<Either<Failure, List<Mission>>> fetchMissions();

  /// Returns Lobby object.
  Stream<Either<Failure, Lobby>> getLobbyStream({String roomUid});

  /// Get [Mission] by UID.
  Future<Either<Failure, Mission>> getMissionByUids({
    @required String chapterUid,
    @required String missionUid,
  });

  /// Join to game by its [roomUid].
  Future<Either<Failure, bool>> joinGame({
    @required String roomUid,
    @required String joinedUid,
  });

  /// Update Lobby.
  Future<Either<Failure, bool>> updateLobby({
    @required String roomUid,
    @required Lobby lobby,
  });
}
