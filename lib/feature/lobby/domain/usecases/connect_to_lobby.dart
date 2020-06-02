import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/lobby.dart';
import '../repositories/lobby_repository.dart';

/// Joins to a game and returns lobby stream.
class ConnectToLobby implements StreamUseCase<Lobby, ConnectToLobbyParams> {
  /// Lobby repository.
  final LobbyRepository repository;

  /// Takes [repository] as parameter.
  ConnectToLobby(this.repository);

  @override
  Stream<Either<Failure, Lobby>> call(ConnectToLobbyParams params) async* {
    final result = await repository.joinGame(
      roomUid: params.roomUid,
      joinedUid: params.joinedUid,
    );

    yield* result.fold((l) async* {
      yield Left(null);
    }, (r) async* {
      yield* repository.getLobbyStream(roomUid: params.roomUid);
    });
  }
}

/// Params for CreateLobby.
class ConnectToLobbyParams extends Equatable {
  /// Room uid.
  final String roomUid;

  /// Joined user uid.
  final String joinedUid;

  /// Params for CreateLobby.
  ConnectToLobbyParams({
    @required this.roomUid,
    @required this.joinedUid,
  });

  @override
  List<Object> get props => [roomUid, joinedUid];
}
