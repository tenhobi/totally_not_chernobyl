import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/lobby.dart';
import '../repositories/lobby_repository.dart';

/// Creates [Lobby] and returns stream.
class CreateLobby implements StreamUseCase<Lobby, CreateLobbyParams> {
  /// Lobby repository.
  final LobbyRepository repository;

  /// Takes [repository] as parameter.
  CreateLobby(this.repository);

  @override
  Stream<Either<Failure, Lobby>> call(CreateLobbyParams params) async* {
    await repository.createLobby(
      roomUid: params.roomUid,
      creatorUid: params.creatorUid,
    );
    yield* repository.getLobbyStream(roomUid: params.roomUid);
  }
}

/// Params for CreateLobby.
class CreateLobbyParams extends Equatable {
  /// Room uid.
  final String roomUid;

  /// Creator user uid.
  final String creatorUid;

  /// Params for CreateLobby.
  CreateLobbyParams({
    @required this.roomUid,
    @required this.creatorUid,
  });

  @override
  List<Object> get props => [roomUid, creatorUid];
}
