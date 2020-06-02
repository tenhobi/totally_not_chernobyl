import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

/// Repository that provides interface for interacting with authentication.
abstract class AuthRepository {
  /// Logs in user.
  /// Returns UID.
  Future<Either<Failure, String>> logIn();

  /// Logs out user.
  Future<Either<Failure, void>> logOut();

  /// Determines if user is logged in.
  Future<Either<Failure, bool>> isLoggedIn();

  /// Returns uid of logged in user.
  Future<Either<Failure, String>> getUid();
}
