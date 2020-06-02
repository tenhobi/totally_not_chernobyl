import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

///
class GetUserUid implements UseCase<String, NoParams> {
  ///
  final AuthRepository repository;

  ///
  GetUserUid(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    final isLoggedIn = await repository.isLoggedIn();
    return isLoggedIn.fold((l) => null, (r) async {
      if (r) {
        final userUid = await repository.getUid();
        return userUid;
      } else {
        return Left(null);
      }
    });
  }
}
