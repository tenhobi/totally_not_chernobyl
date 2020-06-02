import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/lobby.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/game_action.dart';
import '../../domain/entities/game_module.dart';
import '../../domain/entities/game_module_settings.dart';
import '../../domain/repositories/game_repository.dart';

///
class GameRepositoryImpl implements GameRepository {
  /// database route
  final String route = 'games';

  /// Database
  final Firestore db = Firestore.instance;

  @override
  Future<Either<Failure, List<GameAction>>> getActions(
      {@required Game game}) async {
    final actionsList = <GameAction>[];

    final actions = await db
        .collection('chapters')
        .document(game.chapterUid)
        .collection('missions')
        .document(game.missionUid)
        .collection('actions')
        .getDocuments();

    for (var action in actions.documents) {
      final String runtimeType = action.data['runtimeType'];

      actionsList.add(
        GameAction.fromJson(
          action.data..addAll({'runtimeType': runtimeType}),
        ),
      );
    }

    return Right(actionsList);
  }

  @override
  Stream<Either<Failure, Game>> getGameByUid({String gameUid}) async* {
    final snapshots = db.collection(route).document(gameUid).snapshots();

    await for (final snapshot in snapshots) {
      if (!snapshot.exists) continue;

      final data = Game.fromJson(snapshot.data);
      yield Right(data);
    }
  }

  @override
  Future<Either<Failure, List<GameModule>>> getModules({
    @required Game game,
  }) async {
    final modulesList = <GameModule>[];

    final modules = await db
        .collection('chapters')
        .document(game.chapterUid)
        .collection('missions')
        .document(game.missionUid)
        .collection('modules')
        .getDocuments();

    for (var module in modules.documents) {
      final String runtimeType = module.data['runtimeType'];
      final int times = module.data['times'];

      final settings = await db
          .collection('chapters')
          .document(game.chapterUid)
          .collection('missions')
          .document(game.missionUid)
          .collection('modules')
          .document(module.documentID)
          .collection('settings')
          .getDocuments();

      final settingsList = <GameModuleSettings>[];
      for (var setting in settings.documents) {
        if (runtimeType == 'sequence') {
          final all = _parseSequenceValue(setting.data['all']);
          final select = _parseSequenceValue(setting.data['select']);

          settingsList.add(
            SequenceModuleSettings(
              all: all,
              select: select,
            ),
          );
        } else {
          settingsList.add(
            GameModuleSettings.fromJson(
              setting.data..addAll({'runtimeType': runtimeType}),
            ),
          );
        }
      }

      modulesList.add(
        GameModule(
          type: runtimeType,
          times: times,
          settings: settingsList,
        ),
      );
    }

    return Right(modulesList);
  }

  @override
  Future<Either<Failure, bool>> saveGame({
    Game game,
    String gameUid,
  }) async {
    if (game.finished == true) {
      var victory = game.finished &&
          game.modulesLeft != null &&
          game.modulesLeft == 0 &&
          game.endTime != null &&
          game.endTime <= game.time;

      if (game.boom == true) {
        victory = false;
      }

      final lobbies = await db
          .collection('lobbies')
          .where('gameUid', isEqualTo: gameUid)
          .getDocuments();

      for (final lobby in lobbies.documents) {
        print('resetting game ${lobby.documentID}');
        await db
            .collection('lobbies')
            .document(lobby.documentID)
            .updateData({'gameUid': null});

        final lobbyDocument =
            await db.collection('lobbies').document(lobby.documentID).get();

        final lobbyObject = Lobby.fromJson(lobbyDocument.data);
        final players = <String>[lobbyObject.creatorUid, lobbyObject.joinedUid];

        for (final playerUid in players) {
          try {
            await db.collection('users').document(playerUid).updateData({
              'gamesCount': FieldValue.increment(1),
              'winGamesCount': FieldValue.increment(victory ? 1 : 0),
            });
          }
          // ignore: avoid_catches_without_on_clauses
          catch (e) {}
        }
      }
    }

    await db.collection(route).document(gameUid).setData(game.toJson());
    return Right(true);
  }

  List<String> _parseSequenceValue(String value) {
    final List<dynamic> dynamicList = json.decode(value);
    final list = <String>[];

    for (final item in dynamicList) {
      list.add(item as String);
    }

    return list;
  }
}
