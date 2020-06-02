import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/mission.dart';
import '../repositories/lobby_repository.dart';

/// Fetches [Mission] by chapter and mission uid.
class GetMission implements UseCase<Mission, GetMissionParams> {
  /// Lobby repository.
  final LobbyRepository repository;

  /// Takes [repository] as parameter.
  GetMission(this.repository);

  @override
  Future<Either<Failure, Mission>> call(GetMissionParams params) async {
    final result = await repository.getMissionByUids(
      chapterUid: params.chapterUid,
      missionUid: params.missionUid,
    );

    return result.fold((l) {
      return Left(null);
    }, (r) {
      return Right(r);
    });
  }
}

/// Params for CreateLobby.
class GetMissionParams extends Equatable {
  /// Chapter uid.
  final String chapterUid;

  /// Mission uid.
  final String missionUid;

  /// Params for CreateLobby.
  GetMissionParams({
    @required this.chapterUid,
    @required this.missionUid,
  });

  @override
  List<Object> get props => [chapterUid, missionUid];
}
