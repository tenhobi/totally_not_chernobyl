part of 'pump_bloc.dart';

/// States for module Pump.
@freezed
abstract class PumpModuleState with _$PumpModuleState {
  ///
  const factory PumpModuleState.initial() = _Initial;

  ///
  const factory PumpModuleState.inProgress({
    @required PumpModuleSettings settings,
  }) = _InProgress;
}
