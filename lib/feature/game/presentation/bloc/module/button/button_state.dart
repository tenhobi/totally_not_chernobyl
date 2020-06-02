part of 'button_bloc.dart';

/// States for module button.
@freezed
abstract class ButtonModuleState with _$ButtonModuleState {
  ///
  const factory ButtonModuleState.initial() = _Initial;

  ///
  const factory ButtonModuleState.inProgress({
    @required ButtonModuleSettings settings,
  }) = _InProgress;

  ///
  const factory ButtonModuleState.completed() = _Completed;
}
