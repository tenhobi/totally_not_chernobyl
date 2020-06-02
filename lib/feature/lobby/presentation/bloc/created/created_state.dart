part of 'created_bloc.dart';

/// States for Created.
@freezed
abstract class CreatedState with _$CreatedState {
  /// Initial state.
  const factory CreatedState.initial() = _Initial;

  /// Data state.
  const factory CreatedState.data({
    @required Lobby lobby,
    String otherPlayerName,
    @required List<Mission> missions,
  }) = _Data;
}
