part of 'slider_bloc.dart';

/// States for module Slider.
@freezed
abstract class SliderModuleState with _$SliderModuleState {
  ///
  const factory SliderModuleState.initial() = _Initial;

  ///
  const factory SliderModuleState.inProgress({
    @required SliderModuleSettings settings,
  }) = _InProgress;

  ///
  const factory SliderModuleState.completed() = _Completed;
}
