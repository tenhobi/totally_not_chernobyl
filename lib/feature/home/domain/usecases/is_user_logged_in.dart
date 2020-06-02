import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

///
class IsUserLoggedIn implements UseCase<bool, NoParams> {
  ///
  final AuthRepository repository;

  ///
  IsUserLoggedIn(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isLoggedIn();
  }
}
