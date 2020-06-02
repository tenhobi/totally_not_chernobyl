import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:totally_not_chernobyl/feature/game/domain/entities/game.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tGame = Game(
    endTime: 1,
    time: 2,
    errors: 3,
    finished: true,
    modulesLeft: 4,
    chapterUid: 'chapterUid test',
    missionUid: 'missionUid test',
    missionName: 'missionName test',
    workerUid: 'workerUid test',
    manualUid: 'manualUid test',
    boom: false,
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('game.json'));
        // act
        final result = Game.fromJson(jsonMap);
        // assert
        expect(result, tGame);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // arrange
        final result = tGame.toJson();
        // act
        final expectedJsonMap = {
          'endTime': 1,
          'time': 2,
          'errors': 3,
          'finished': true,
          'modulesLeft': 4,
          'chapterUid': 'chapterUid test',
          'missionUid': 'missionUid test',
          'missionName': 'missionName test',
          'workerUid': 'workerUid test',
          'manualUid': 'manualUid test',
          'boom': false
        };
        // assert
        expect(result, expectedJsonMap);
      },
    );
  });
}
