part of 'game_bloc.dart';

/// States for game.
@freezed
abstract class GameState with _$GameState {
  ///
  const factory GameState.initial() = _Initial;

  ///
  const factory GameState.worker() = _Worker;

  ///
  const factory GameState.manual() = _Manual;

  ///
  const factory GameState.stats() = _Stats;
}
