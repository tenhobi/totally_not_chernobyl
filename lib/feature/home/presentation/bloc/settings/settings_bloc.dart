import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_bloc.freezed.dart';
part 'settings_event.dart';
part 'settings_state.dart';

/// {@template settings_bloc}
/// Manages settings of language etc.
/// {@endtemplate}
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// {@macro settings_bloc}
  SettingsBloc();

  @override
  SettingsState get initialState => SettingsState(
        language: Locale('en', 'US'),
      );

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    yield SettingsState(language: event.language);
  }
}
