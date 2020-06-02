part of 'bits_bloc.dart';

/// Events for Bits module.
@freezed
abstract class BitsModuleEvent with _$BitsModuleEvent {
  ///
  const factory BitsModuleEvent.setUp({
    @required GameModule module,
  }) = _SetUp;

  ///
  const factory BitsModuleEvent.attempt({
    @required int value,
  }) = _Attempt;
}
