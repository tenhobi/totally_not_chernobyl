import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/game.dart';
import '../repositories/game_repository.dart';

/// Saves game by game uid.
class SaveGame implements UseCase<bool, SaveGameParams> {
  /// Repository.
  final GameRepository repository;

  /// Takes [repository].
  SaveGame(this.repository);

  @override
  Future<Either<Failure, bool>> call(SaveGameParams params) async {
    final result = await repository.saveGame(
      game: params.game,
      gameUid: params.gameUid,
    );

    return result;
  }
}

/// Params for CreateLobby.
class SaveGameParams extends Equatable {
  ///
  final Game game;

  ///
  final String gameUid;

  /// Params for CreateLobby.
  SaveGameParams({
    @required this.game,
    @required this.gameUid,
  });

  @override
  List<Object> get props => [game, gameUid];
}
