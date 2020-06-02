part of 'login_bloc.dart';

/// Events for login.
@freezed
abstract class LoginEvent with _$LoginEvent {
  /// User attepted to login.
  const factory LoginEvent.login() = _Login;

  /// User registered.
  const factory LoginEvent.register({
    @required String uid,
    @required String username,
    @required String language,
  }) = _Register;
}
