import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/mission.dart';
import '../repositories/lobby_repository.dart';

/// Fetches missions.
class GetMissions implements UseCase<List<Mission>, NoParams> {
  /// Lobby repository.
  final LobbyRepository repository;

  /// Takes [repository] as parameter.
  GetMissions(this.repository);

  @override
  Future<Either<Failure, List<Mission>>> call(NoParams params) async {
    final result = await repository.fetchMissions();

    return result.fold((l) {
      return Left(null);
    }, (r) {
      return Right(r);
    });
  }
}
