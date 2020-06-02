import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// {@template get_user_by_id}
/// UseCase for getting user by id.
/// {@endtemplate}
class GetUserByUid extends UseCase<User, GetUserByUidParams> {
  /// Implementation of user repository provided by injection.
  final UserRepository repository;

  /// {@macro get_user_by_id}
  GetUserByUid(this.repository);

  /// UseCase.
  Future<Either<Failure, User>> call(GetUserByUidParams params) {
    return repository.getUserByUid(params.uid);
  }
}

/// Params for GetUserByUid.
class GetUserByUidParams extends Equatable {
  /// Identificator.
  final String uid;

  /// Params for GetUserByUid.
  GetUserByUidParams({@required this.uid});

  @override
  List<Object> get props => [uid];
}
