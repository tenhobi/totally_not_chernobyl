part of 'game_bloc.dart';

/// Events for game.
@freezed
abstract class GameEvent with _$GameEvent {
  ///
  const factory GameEvent.toWorker() = _ToWorker;

  ///
  const factory GameEvent.toManual() = _ToManual;

  ///
  const factory GameEvent.toStats() = _ToStats;
}
