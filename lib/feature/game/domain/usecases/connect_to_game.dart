import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/game.dart';
import '../repositories/game_repository.dart';

/// Connects to game by game uid.
class ConnectToGame implements StreamUseCase<Game, ConnectToGameParams> {
  /// Repository.
  final GameRepository repository;

  /// Takes [repository].
  ConnectToGame(this.repository);

  @override
  Stream<Either<Failure, Game>> call(ConnectToGameParams params) async* {
    final result = await repository.getGameByUid(
      gameUid: params.gameUid,
    );

    yield* result;
  }
}

/// Params for CreateLobby.
class ConnectToGameParams extends Equatable {
  ///
  final String gameUid;

  /// Params for CreateLobby.
  ConnectToGameParams({
    @required this.gameUid,
  });

  @override
  List<Object> get props => [gameUid];
}
