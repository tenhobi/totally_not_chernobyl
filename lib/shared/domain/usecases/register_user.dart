import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

/// {@template register_user}
/// UseCase for registering an user to database.
/// {@endtemplate}
class RegisterUser extends UseCase<bool, RegisterUserParams> {
  /// Implementation of user repository provided by injection.
  final UserRepository repository;

  /// {@macro register_user}
  RegisterUser(this.repository);

  /// UseCase.
  Future<Either<Failure, bool>> call(RegisterUserParams params) {
    return repository.registerUser(
        params.uid, params.username, params.language);
  }
}

/// Params for RegisterUser.
class RegisterUserParams extends Equatable {
  /// Uid.
  final String uid;

  /// Nickname.
  final String username;

  /// Language of the user.
  final String language;

  /// Params for RegisterUser.
  RegisterUserParams({
    @required this.uid,
    @required this.username,
    @required this.language,
  });

  @override
  List<Object> get props => [username, language];
}
