import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/lobby.dart';
import '../repositories/lobby_repository.dart';

/// Creates game.
class CreateGame implements UseCase<String, CreateGameParams> {
  /// Lobby repository.
  final LobbyRepository repository;

  /// Takes [repository] as parameter.
  CreateGame(this.repository);

  @override
  Future<Either<Failure, String>> call(CreateGameParams params) async {
    final create = repository.createGame(
      lobby: params.lobby,
      missionName: params.missionName,
    );

    return create;
  }
}

/// Params for CreateGame.
class CreateGameParams extends Equatable {
  /// Lobby object.
  final Lobby lobby;

  /// Mission name.
  final String missionName;

  /// Params for CreateGame.
  CreateGameParams({
    @required this.lobby,
    @required this.missionName,
  });

  @override
  List<Object> get props => [lobby, missionName];
}
