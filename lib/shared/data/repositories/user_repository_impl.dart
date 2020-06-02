import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

/// Implementation of [UserRepository].
class UserRepositoryImpl implements UserRepository {
  /// Database route.
  final String route = 'users';

  /// Database.
  final Firestore db = Firestore.instance;

  /// Authentication.
  final FirebaseAuth _firebaseAuth;

  /// Takes [firebaseAuth] as parameter.
  UserRepositoryImpl({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<Either<Failure, User>> getUserByUid(String uid) async {
    final userDocument = await db.collection(route).document(uid).get();

    if (!userDocument.exists) return Left(null);

    return Right(User.fromJson(userDocument.data));
  }

  @override
  Future<Either<Failure, bool>> isUserRegistered(String uid) async {
    final userDocument = await db.collection(route).document(uid).get();
    return Right(userDocument.exists);
  }

  @override
  Future<Either<Failure, bool>> registerUser(
      String uid, String username, String language) async {
    final currentUser = await _firebaseAuth.currentUser();
    final user = User(
      language: language,
      username: username,
      photoUrl: currentUser.photoUrl,
    );
    db.collection(route).document(uid).setData(user.toJson());
    return Right(true);
  }

  @override
  Future<Either<Failure, bool>> saveUser(String uid, User user) async {
    db.collection(route).document(uid).setData(user.toJson());
    return Right(true);
  }
}
