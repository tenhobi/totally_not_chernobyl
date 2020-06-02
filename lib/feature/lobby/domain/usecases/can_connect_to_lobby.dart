import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/lobby_repository.dart';

/// Usecase that determines if user can join to the lobby.
class CanConnectToLobby implements UseCase<bool, CanConnectToLobbyParams> {
  /// Lobby repository.
  final LobbyRepository repository;

  /// Takes [repository] as parameter.
  CanConnectToLobby(this.repository);

  @override
  Future<Either<Failure, bool>> call(CanConnectToLobbyParams params) async {
    final result = await repository.canJoinGame(
      roomUid: params.roomUid,
    );

    return result.fold((l) {
      return Left(null);
    }, (r) {
      return Right(true);
    });
  }
}

/// Params for CreateLobby.
class CanConnectToLobbyParams extends Equatable {
  ///
  final String roomUid;

  /// Params for CreateLobby.
  CanConnectToLobbyParams({
    @required this.roomUid,
  });

  @override
  List<Object> get props => [roomUid];
}
