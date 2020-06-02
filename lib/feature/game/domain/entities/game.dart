import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game.freezed.dart';
part 'game.g.dart';

/// {@template game}
/// Game entity. Describes the game itself.
/// {@endtemplate}
@freezed
abstract class Game with _$Game {
  /// {@macro user}
  const factory Game({
    int endTime,
    @required int time,
    @required int errors,
    @Default(false) bool finished,
    int modulesLeft,
    @required String chapterUid,
    @required String missionUid,
    @required String missionName,
    @required String workerUid,
    @required String manualUid,
    @Default(false) bool boom,
  }) = _Game;

  /// Converts JSON data to [Game].
  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}
