import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  /// Firebase authentication.
  final FirebaseAuth _firebaseAuth;

  /// Google SignIn provider.
  final GoogleSignIn _googleSignIn;

  /// Takes [firebaseAuth] and [googleSignin] as parameters.
  AuthRepositoryImpl({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  @override
  Future<Either<Failure, String>> logIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      print(googleUser);
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      final currentUser = await _firebaseAuth.currentUser();
      return Right(currentUser?.uid);
    }
    // ignore: avoid_catches_without_on_clauses
    catch (_) {
      return Left(null);
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);

    return Right(null);
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    final currentUser = await _firebaseAuth.currentUser();

    if (currentUser != null) return Right(true);
    return Right(false);
  }

  @override
  Future<Either<Failure, String>> getUid() async {
    final currentUser = await _firebaseAuth.currentUser();

    if (currentUser == null) return Left(null);

    return Right(currentUser.uid);
  }
}
