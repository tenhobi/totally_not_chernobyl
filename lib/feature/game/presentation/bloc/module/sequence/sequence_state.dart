part of 'sequence_bloc.dart';

/// States for module Sequence.
@freezed
abstract class SequenceModuleState with _$SequenceModuleState {
  ///
  const factory SequenceModuleState.initial() = _Initial;

  ///
  const factory SequenceModuleState.inProgress({
    @required SequenceModuleSettings settings,
  }) = _InProgress;

  ///
  const factory SequenceModuleState.completed() = _Completed;
}
