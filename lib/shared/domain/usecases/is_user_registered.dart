import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

/// {@template register_user}
/// UseCase for checking if an user is in the database.
/// {@endtemplate}
class IsUserRegistered extends UseCase<bool, IsUserRegisteredParams> {
  /// Implementation of user repository provided by injection.
  final UserRepository repository;

  /// {@macro register_user}
  IsUserRegistered(this.repository);

  /// UseCase.
  Future<Either<Failure, bool>> call(IsUserRegisteredParams params) {
    return repository.isUserRegistered(params.uid);
  }
}

/// Params for IsUserRegistered.
class IsUserRegisteredParams extends Equatable {
  ///
  final String uid;

  /// Params for RegisterUser.
  IsUserRegisteredParams({@required this.uid});

  @override
  List<Object> get props => [uid];
}
