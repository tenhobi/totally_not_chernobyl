import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:totally_not_chernobyl/shared/domain/entities/user.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tUser = User(
    username: 'test username',
    language: 'test language',
    photoUrl: 'photo url',
    gamesCount: 3,
    winGamesCount: 1,
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('user.json'));
        // act
        final result = User.fromJson(jsonMap);
        // assert
        expect(result, tUser);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // arrange
        final result = tUser.toJson();
        // act
        final expectedJsonMap = {
          'username': 'test username',
          'language': 'test language',
          'photoUrl': 'photo url',
          'gamesCount': 3,
          'winGamesCount': 1,
        };
        // assert
        expect(result, expectedJsonMap);
      },
    );
  });
}
