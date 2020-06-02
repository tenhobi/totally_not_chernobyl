import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../entities/game.dart';
import '../entities/game_action.dart';
import '../entities/game_module.dart';

///
abstract class GameRepository {
  /// Get actions for [Game].
  Future<Either<Failure, List<GameAction>>> getActions({
    @required Game game,
  });

  /// Get [Game] by UID.
  Stream<Either<Failure, Game>> getGameByUid({
    @required String gameUid,
  });

  /// Get modules for [Game].
  Future<Either<Failure, List<GameModule>>> getModules({
    @required Game game,
  });

  /// Save [Game].
  Future<Either<Failure, bool>> saveGame({
    @required Game game,
    @required String gameUid,
  });
}
