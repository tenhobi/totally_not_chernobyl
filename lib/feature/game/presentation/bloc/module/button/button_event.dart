part of 'button_bloc.dart';

/// Events for button module.
@freezed
abstract class ButtonModuleEvent with _$ButtonModuleEvent {
  ///
  const factory ButtonModuleEvent.setUp({
    @required GameModule module,
  }) = _SetUp;

  ///
  const factory ButtonModuleEvent.attempt({
    @required int time,
  }) = _Attempt;
}
