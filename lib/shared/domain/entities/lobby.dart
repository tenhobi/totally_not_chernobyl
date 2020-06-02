import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lobby.freezed.dart';
part 'lobby.g.dart';

/// {@template lobby}
/// Lobby entity. Describes the setting of the game done in lobby.
/// {@endtemplate}
@freezed
abstract class Lobby with _$Lobby {
  /// {@macro user}
  const factory Lobby({
    @nullable @required String roomId,
    @required String creatorUid,
    @Default(false) bool creatorReady,
    String joinedUid,
    @Default(false) bool joinedReady,
    String workerUid,
    String chapterUid,
    String missionUid,
    String gameUid,
  }) = _Lobby;

  /// Converts JSON data to [Lobby].
  factory Lobby.fromJson(Map<String, dynamic> json) => _$LobbyFromJson(json);
}
