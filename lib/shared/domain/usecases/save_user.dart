import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// {@template register_user}
/// UseCase for registering an user to database.
/// {@endtemplate}
class SaveUser extends UseCase<bool, SaveUserParams> {
  /// Implementation of user repository provided by injection.
  final UserRepository repository;

  /// {@macro register_user}
  SaveUser(this.repository);

  /// UseCase.
  Future<Either<Failure, bool>> call(SaveUserParams params) {
    return repository.saveUser(params.uid, params.user);
  }
}

/// Params for SaveUser.
class SaveUserParams extends Equatable {
  /// Uid.
  final String uid;

  /// User data.
  final User user;

  /// Params for RegisterUser.
  SaveUserParams({
    @required this.uid,
    @required this.user,
  });

  @override
  List<Object> get props => [uid, user];
}
