import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_module_settings.freezed.dart';
part 'game_module_settings.g.dart';

/// Game module entity.
@freezed
abstract class GameModuleSettings with _$GameModuleSettings {
  /// Button module.
  const factory GameModuleSettings.button({
    @required String text,
    @required String color,
    @required int number,
  }) = ButtonModuleSettings;

  /// Slider module.
  const factory GameModuleSettings.slider({
    @required int max,
    @required int number,
  }) = SliderModuleSettings;

  /// Sequence module.
  const factory GameModuleSettings.sequence({
    List<String> select,
    List<String> all,
  }) = SequenceModuleSettings;

  /// Bits module.
  const factory GameModuleSettings.bits({
    String text,
    int number,
  }) = BitsModuleSettings;

  /// Pump module.
  const factory GameModuleSettings.pump({
    int time,
  }) = PumpModuleSettings;

  /// Converts JSON data to [Game].
  factory GameModuleSettings.fromJson(Map<String, dynamic> json) =>
      _$GameModuleSettingsFromJson(json);
}
