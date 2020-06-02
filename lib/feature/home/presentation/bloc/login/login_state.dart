part of 'login_bloc.dart';

/// States for login.
@freezed
abstract class LoginState with _$LoginState {
  /// State with button etc. waiting for login.
  const factory LoginState.initial() = _Initial;

  /// Progress indicator -- trying to login user.
  const factory LoginState.loading() = _Loading;

  /// Additional registration is required.
  const factory LoginState.registration({String uid}) = _Registration;

  /// Login failed.
  const factory LoginState.failure({String error}) = _Failure;
}
