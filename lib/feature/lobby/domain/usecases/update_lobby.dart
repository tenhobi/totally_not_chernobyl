import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/lobby.dart';
import '../repositories/lobby_repository.dart';

/// Updates [Lobby] object.
class UpdateLobby implements UseCase<bool, UpdateLobbyParams> {
  /// Lobby repository.
  final LobbyRepository repository;

  /// Takes [repository] as parameter.
  UpdateLobby(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateLobbyParams params) async {
    final update = await repository.updateLobby(
      roomUid: params.roomUid,
      lobby: params.lobby,
    );

    return update;
  }
}

/// Params for CreateLobby.
class UpdateLobbyParams extends Equatable {
  /// Room uid.
  final String roomUid;

  /// Lobby object.
  final Lobby lobby;

  /// Params for CreateLobby.
  UpdateLobbyParams({
    @required this.roomUid,
    @required this.lobby,
  });

  @override
  List<Object> get props => [roomUid, lobby];
}
