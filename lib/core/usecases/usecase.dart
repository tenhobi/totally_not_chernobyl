import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Interface for usecases.
// ignore: one_member_abstracts
abstract class UseCase<Type, Params> {
  /// Makes an Object callable.
  Future<Either<Failure, Type>> call(Params params);
}

/// Interface for usecases returning [Stream].
// ignore: one_member_abstracts
abstract class StreamUseCase<Type, Params> {
  /// Makes an Object callable.
  Stream<Either<Failure, Type>> call(Params params);
}

/// Generic class for no params.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
