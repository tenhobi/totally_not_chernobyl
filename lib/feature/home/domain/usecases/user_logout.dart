import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

///
class UserLogOut implements UseCase<void, NoParams> {
  ///
  final AuthRepository repository;

  ///
  UserLogOut(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logOut();
  }
}
