import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/game.dart';
import '../entities/game_module.dart';
import '../repositories/game_repository.dart';

/// Fetches modules from game.
class FetchModules implements UseCase<List<GameModule>, FetchModulesParams> {
  /// Repository.
  final GameRepository repository;

  /// Takes [repository].
  FetchModules(this.repository);

  @override
  Future<Either<Failure, List<GameModule>>> call(
    FetchModulesParams params,
  ) async {
    final result = await repository.getModules(
      game: params.game,
    );

    return result;
  }
}

/// Params for CreateLobby.
class FetchModulesParams extends Equatable {
  /// Game object.
  final Game game;

  /// Params for CreateLobby.
  FetchModulesParams({
    @required this.game,
  });

  @override
  List<Object> get props => [game];
}
