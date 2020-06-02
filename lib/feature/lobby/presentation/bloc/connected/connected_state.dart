part of 'connected_bloc.dart';

/// States for connected.
@freezed
abstract class ConnectedState with _$ConnectedState {
  /// Initial state.
  const factory ConnectedState.initial() = _Initial;

  /// Data state.
  const factory ConnectedState.data({
    @required Lobby lobby,
    String otherPlayerName,
    String missionName,
  }) = _Data;
}
