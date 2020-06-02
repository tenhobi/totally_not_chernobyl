import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_action.freezed.dart';
part 'game_action.g.dart';

/// Game action entity.
@freezed
abstract class GameAction with _$GameAction {
  /// Shake action.
  const factory GameAction.shake({
    int time,
  }) = ShakeAction;

  /// placeholder for API
  const factory GameAction.xyz({
    int time,
  }) = _XyzAction;

  /// Converts JSON data to [Game].
  factory GameAction.fromJson(Map<String, dynamic> json) =>
      _$GameActionFromJson(json);
}
