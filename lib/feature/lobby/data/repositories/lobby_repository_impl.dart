import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/lobby.dart';
import '../../../game/domain/entities/game.dart';
import '../../domain/entities/mission.dart';
import '../../domain/repositories/lobby_repository.dart';

/// Implementation of [LobbyRepository].
class LobbyRepositoryImpl implements LobbyRepository {
  /// database route
  final String route = 'lobbies';

  /// Database
  final Firestore db = Firestore.instance;

  @override
  Future<Either<Failure, bool>> canJoinGame({
    @required String roomUid,
  }) async {
    final snapshot = await db.collection(route).document(roomUid).get();
    if (!snapshot.exists) return Left(null);
    return Right(true);
  }

  @override
  Future<Either<Failure, String>> createGame({
    Lobby lobby,
    String missionName,
  }) async {
    final mission = await db
        .collection('chapters')
        .document(lobby.chapterUid)
        .collection('missions')
        .document(lobby.missionUid)
        .get();

    final int time = mission.data['time'];
    final int errors = mission.data['errors'];

    final game = Game(
      time: time,
      errors: errors,
      finished: false,
      chapterUid: lobby.chapterUid,
      missionUid: lobby.missionUid,
      missionName: missionName,
      workerUid: lobby.workerUid,
      manualUid: lobby.workerUid == lobby.creatorUid
          ? lobby.joinedUid
          : lobby.creatorUid,
    );

    final gameDocument = await db.collection('games').add(game.toJson());

    return Right(gameDocument.documentID);
  }

  @override
  Future<Either<Failure, bool>> createLobby({
    @required String roomUid,
    @required String creatorUid,
  }) async {
    final lobby = Lobby(roomId: roomUid, creatorUid: creatorUid);

    db.collection(route).document(roomUid).setData(lobby.toJson());

    return Right(true);
  }

  @override
  Future<Either<Failure, List<Mission>>> fetchMissions() async {
    final missionsList = <Mission>[];

    var chapters =
        await db.collection('chapters').orderBy('order').getDocuments();

    for (final chapter in chapters.documents) {
      var missions = await db
          .collection('chapters')
          .document(chapter.documentID)
          .collection('missions')
          .orderBy('order')
          .getDocuments();

      for (var mission in missions.documents) {
        missionsList.add(
          Mission(
            chapterUid: chapter.documentID,
            missionUid: mission.documentID,
            missionName:
                // ignore: lines_longer_than_80_chars
                '${chapter.data['order']}.${mission.data['order']} ${mission.data['name']}',
          ),
        );
      }
    }

    return Right(missionsList);
  }

  @override
  Stream<Either<Failure, Lobby>> getLobbyStream({
    @required String roomUid,
  }) async* {
    final snapshots = db.collection(route).document(roomUid).snapshots();

    await for (final snapshot in snapshots) {
      if (!snapshot.exists) continue;

      final data = Lobby.fromJson(snapshot.data);
      yield Right(data);
    }
  }

  @override
  Future<Either<Failure, Mission>> getMissionByUids({
    @required String chapterUid,
    @required String missionUid,
  }) async {
    final chapter = await db.collection('chapters').document(chapterUid).get();

    final mission = await db
        .collection('chapters')
        .document(chapterUid)
        .collection('missions')
        .document(missionUid)
        .get();

    if (!mission.exists || !chapter.exists) return Left(null);

    return Right(
      Mission(
        chapterUid: chapterUid,
        missionUid: missionUid,
        missionName:
            // ignore: lines_longer_than_80_chars
            '${chapter.data['order']}.${mission.data['order']} ${mission.data['name']}',
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> joinGame({
    @required String roomUid,
    @required String joinedUid,
  }) async {
    final document = await db.collection(route).document(roomUid);

    final snapshot = await document.get();

    if (!snapshot.exists) return Left(null);

    await document.updateData({'joinedUid': joinedUid});
    return Right(true);
  }

  @override
  Future<Either<Failure, bool>> updateLobby({
    @required String roomUid,
    @required Lobby lobby,
  }) async {
    print(lobby);
    await db.collection(route).document(roomUid).setData(lobby.toJson());
    return Right(true);
  }
}
