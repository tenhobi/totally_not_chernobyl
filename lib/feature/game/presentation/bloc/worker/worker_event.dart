part of 'worker_bloc.dart';

/// Events for game manual.
@freezed
abstract class WorkerEvent with _$WorkerEvent {
  ///
  const factory WorkerEvent.connect() = _Connect;

  ///
  const factory WorkerEvent.update({@required Game game}) = _Update;

  ///
  const factory WorkerEvent.save({@required Game game}) = _Save;

  ///
  const factory WorkerEvent.completeModule() = _CompleteModule;

  ///
  const factory WorkerEvent.fail({
    @Default(false) bool total,
  }) = _Fail;
}
