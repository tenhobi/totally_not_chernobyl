part of 'worker_bloc.dart';

/// States for game worker.
@freezed
abstract class WorkerState with _$WorkerState {
  ///
  const factory WorkerState.initial() = _Initial;

  ///
  const factory WorkerState.data({
    @required Game game,
    @required List<GameModule> modules,
    @required int modulesLeft,
    @required int errorsLeft,
    @required List<GameAction> actions,
  }) = _Data;
}
