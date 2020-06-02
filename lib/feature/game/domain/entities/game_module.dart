import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

import 'game_module_settings.dart';

part 'game_module.freezed.dart';

/// Game module entity.
@freezed
abstract class GameModule with _$GameModule {
  /// Button module.
  const factory GameModule({
    @required String type,
    @required int times,
    @required List<GameModuleSettings> settings,
  }) = _GameModule;
}
