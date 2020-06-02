part of 'connected_bloc.dart';

/// Events for connected.
@freezed
abstract class ConnectedEvent with _$ConnectedEvent {
  /// Connect to Lobby.
  const factory ConnectedEvent.connect({
    @required String roomUid,
    @required String playerUid,
  }) = _Connect;

  /// Update [lobby].
  const factory ConnectedEvent.update({
    @required Lobby lobby,
  }) = _Update;
}
