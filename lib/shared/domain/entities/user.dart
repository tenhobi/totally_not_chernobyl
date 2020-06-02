import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// {@template user}
/// User entity.
/// {@endtemplate}
@freezed
abstract class User with _$User {
  /// {@macro user}
  const factory User({
    @required String username,
    @required String language,
    @required String photoUrl,
    @Default(0) int gamesCount,
    @Default(0) int winGamesCount,
  }) = _User;

  /// Converts JSON data to [User].
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
