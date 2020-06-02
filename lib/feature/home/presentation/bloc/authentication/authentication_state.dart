part of 'authentication_bloc.dart';

/// States for authentication.
@freezed
abstract class AuthenticationState with _$AuthenticationState {
  /// Authentication is uninitialized.
  const factory AuthenticationState.uninitialized() = _Uninitialized;

  /// User is authenticated.
  const factory AuthenticationState.authenticated({@required String uid}) =
      _Authenticated;

  /// User is unauthenticated.
  const factory AuthenticationState.unauthenticated() = _Unauthenticated;

  /// User has registered, proceed to registration.
  //const factory AuthenticationState.notRegistered() = _NotRegistered;

  /// Authentication is loading.
  const factory AuthenticationState.loading() = _Loading;
}
