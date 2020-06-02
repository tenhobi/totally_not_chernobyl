part of 'settings_bloc.dart';

/// States for login.
@freezed
abstract class SettingsState with _$SettingsState {
  /// State with button etc. waiting for login.
  const factory SettingsState({
    @required Locale language,
  }) = _SettingsState;
}
