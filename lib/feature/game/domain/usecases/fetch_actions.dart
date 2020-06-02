import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/game.dart';
import '../entities/game_action.dart';
import '../repositories/game_repository.dart';

/// Fetches actions from game.
class FetchActions implements UseCase<List<GameAction>, FetchActionsParams> {
  /// Repository.
  final GameRepository repository;

  /// Takes [repository].
  FetchActions(this.repository);

  @override
  Future<Either<Failure, List<GameAction>>> call(
    FetchActionsParams params,
  ) async {
    final result = await repository.getActions(
      game: params.game,
    );

    return result;
  }
}

/// Params for CreateLobby.
class FetchActionsParams extends Equatable {
  /// Game object.
  final Game game;

  /// Params for CreateLobby.
  FetchActionsParams({
    @required this.game,
  });

  @override
  List<Object> get props => [game];
}
