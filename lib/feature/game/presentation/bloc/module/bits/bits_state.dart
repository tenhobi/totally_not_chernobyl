part of 'bits_bloc.dart';

/// States for module Bits.
@freezed
abstract class BitsModuleState with _$BitsModuleState {
  ///
  const factory BitsModuleState.initial() = _Initial;

  ///
  const factory BitsModuleState.inProgress({
    @required BitsModuleSettings settings,
  }) = _InProgress;

  ///
  const factory BitsModuleState.completed() = _Completed;
}
