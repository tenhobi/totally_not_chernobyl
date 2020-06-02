import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:totally_not_chernobyl/shared/domain/entities/lobby.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tLobby = Lobby(
    roomId: 'roomId test',
    creatorUid: 'creatorUid test',
    creatorReady: true,
    joinedUid: 'joinedUid test',
    joinedReady: true,
    workerUid: 'workerUi test',
    chapterUid: 'chapterUid test',
    missionUid: 'missionUid test',
    gameUid: 'gameUid test',
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('lobby.json'));
        // act
        final result = Lobby.fromJson(jsonMap);
        // assert
        expect(result, tLobby);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // arrange
        final result = tLobby.toJson();
        // act
        final expectedJsonMap = {
          'roomId': 'roomId test',
          'creatorUid': 'creatorUid test',
          'creatorReady': true,
          'joinedUid': 'joinedUid test',
          'joinedReady': true,
          'workerUid': 'workerUi test',
          'chapterUid': 'chapterUid test',
          'missionUid': 'missionUid test',
          'gameUid': 'gameUid test',
        };
        // assert
        expect(result, expectedJsonMap);
      },
    );
  });
}
