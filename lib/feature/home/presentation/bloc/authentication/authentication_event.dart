part of 'authentication_bloc.dart';

/// Events for authentication.
@freezed
abstract class AuthenticationEvent with _$AuthenticationEvent {
  /// Describes initial event. App started and authentication is required.
  const factory AuthenticationEvent.appStarted() = _AppStarted;

  /// Describes that user is logged in.
  const factory AuthenticationEvent.loggedIn({@required String uid}) =
      _LoggedIn;

  /// Describes that user is logged out.
  const factory AuthenticationEvent.loggedOut() = _LoggedOut;
}
