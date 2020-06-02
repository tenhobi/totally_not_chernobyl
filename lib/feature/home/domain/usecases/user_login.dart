import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

///
class UserLogIn implements UseCase<String, NoParams> {
  ///
  final AuthRepository repository;

  ///
  UserLogIn(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.logIn();
  }
}
