part of 'slider_bloc.dart';

/// Events for Slider module.
@freezed
abstract class SliderModuleEvent with _$SliderModuleEvent {
  ///
  const factory SliderModuleEvent.setUp({
    @required GameModule module,
  }) = _SetUp;

  ///
  const factory SliderModuleEvent.attempt({
    @required int value,
  }) = _Attempt;
}
