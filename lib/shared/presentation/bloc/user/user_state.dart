part of 'user_bloc.dart';

/// States for login.
@freezed
abstract class UserState with _$UserState {
  /// State with button etc. waiting for login.
  const factory UserState({
    @required User user,
  }) = _UserState;
}
