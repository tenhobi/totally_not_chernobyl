part of 'sequence_bloc.dart';

/// Events for Sequence module.
@freezed
abstract class SequenceModuleEvent with _$SequenceModuleEvent {
  ///
  const factory SequenceModuleEvent.setUp({
    @required GameModule module,
  }) = _SetUp;

  ///
  const factory SequenceModuleEvent.attempt({
    @required List<String> value,
  }) = _Attempt;
}
