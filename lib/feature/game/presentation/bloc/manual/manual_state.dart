part of 'manual_bloc.dart';

/// States for game manual.
@freezed
abstract class ManualState with _$ManualState {
  ///
  const factory ManualState.initial() = _Initial;

  ///
  const factory ManualState.data({
    @required Game game,
    @required List<GameModule> modules,
    @required List<GameAction> actions,
  }) = _Data;
}
