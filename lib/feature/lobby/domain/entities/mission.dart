import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission.freezed.dart';
part 'mission.g.dart';

/// {@template mission}
/// Mission entity.
/// {@endtemplate}
@freezed
abstract class Mission with _$Mission {
  /// {@macro user}
  const factory Mission({
    @required String missionUid,
    @required String chapterUid,
    @required String missionName,
  }) = _Mission;

  /// Converts JSON data to [mission].
  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);
}
