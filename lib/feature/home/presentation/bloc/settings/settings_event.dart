part of 'settings_bloc.dart';

/// Events for settings.
@freezed
abstract class SettingsEvent with _$SettingsEvent {
  ///
  const factory SettingsEvent({
    @required Locale language,
  }) = _SettingsEvent;
}
