part of 'lobby_bloc.dart';

/// Events for lobby.
@freezed
abstract class LobbyEvent with _$LobbyEvent {
  ///
  const factory LobbyEvent.create() = _Create;

  ///
  const factory LobbyEvent.join() = _Join;

  ///
  const factory LobbyEvent.connect({
    @required String roomId,
  }) = _Connect;
}
