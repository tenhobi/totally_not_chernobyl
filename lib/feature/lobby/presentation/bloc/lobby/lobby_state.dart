part of 'lobby_bloc.dart';

/// States for lobby.
@freezed
abstract class LobbyState with _$LobbyState {
  /// Initial state.
  const factory LobbyState.initial() = _Initial;

  /// Lobby were created.
  const factory LobbyState.created() = _Created;

  /// Lobby joining.
  const factory LobbyState.joining({
    @Default(false) bool failed,
  }) = _Joining;

  /// Lobby were connected.
  const factory LobbyState.connected({
    @required String roomUid,
  }) = _Connected;
}
