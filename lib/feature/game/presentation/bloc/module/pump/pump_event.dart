part of 'pump_bloc.dart';

/// Events for Pump module.
@freezed
abstract class PumpModuleEvent with _$PumpModuleEvent {
  ///
  const factory PumpModuleEvent.setUp({
    @required GameModule module,
  }) = _SetUp;

  ///
  const factory PumpModuleEvent.failed() = _Failed;
}
