part of 'user_bloc.dart';

/// Events for settings.
@freezed
abstract class UserEvent with _$UserEvent {
  ///
  const factory UserEvent.setUp({
    @required User user,
  }) = _UserEventSetUp;

  ///
  const factory UserEvent.fetch() = _UserEventFetch;
}
