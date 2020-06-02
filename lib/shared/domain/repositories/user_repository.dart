import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/user.dart';

/// Repository that provides interface for interacting with user.
// ignore: one_member_abstracts
abstract class UserRepository {
  /// Returns [User] by its [uid].
  Future<Either<Failure, User>> getUserByUid(String uid);

  /// Registers a [User] and returns a [bool].
  Future<Either<Failure, bool>> registerUser(
    String uid,
    String username,
    String language,
  );

  /// Saves a [User] by its [uid] and returns a [bool].
  Future<Either<Failure, bool>> saveUser(
    String uid,
    User user,
  );

  /// Determines if a [User] by uis [uid] is already registered.
  Future<Either<Failure, bool>> isUserRegistered(String uid);
}
