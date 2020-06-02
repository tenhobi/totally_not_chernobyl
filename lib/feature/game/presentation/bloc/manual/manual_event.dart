part of 'manual_bloc.dart';

/// Events for game manual.
@freezed
abstract class ManualEvent with _$ManualEvent {
  ///
  const factory ManualEvent.connect() = _Connect;

  ///
  const factory ManualEvent.update({
    @required Game game,
  }) = _Update;

  ///
  const factory ManualEvent.save({
    @required Game game,
  }) = _Save;
}
