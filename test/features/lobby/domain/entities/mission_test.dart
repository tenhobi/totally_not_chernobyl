import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/entities/mission.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tMission = Mission(
    chapterUid: 'chapterUid test',
    missionUid: 'missionUid test',
    missionName: 'missionName test',
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('mission.json'));
        // act
        final result = Mission.fromJson(jsonMap);
        // assert
        expect(result, tMission);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // arrange
        final result = tMission.toJson();
        // act
        final expectedJsonMap = {
          'chapterUid': 'chapterUid test',
          'missionUid': 'missionUid test',
          'missionName': 'missionName test',
        };
        // assert
        expect(result, expectedJsonMap);
      },
    );
  });
}
