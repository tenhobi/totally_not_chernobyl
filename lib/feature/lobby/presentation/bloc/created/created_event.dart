part of 'created_bloc.dart';

/// Events for created lobby.
@freezed
abstract class CreatedEvent with _$CreatedEvent {
  /// Create lobby.
  const factory CreatedEvent.create() = _Create;

  /// Update with new data.
  const factory CreatedEvent.update({
    @required Lobby lobby,
  }) = _Update;

  /// Start game.
  const factory CreatedEvent.start({
    @required Lobby lobby,
    @required String missionName,
  }) = _Start;
}
