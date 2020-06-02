import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/entities/mission.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/repositories/lobby_repository.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/usecases/get_mission.dart';

class MockLobbyRepository extends Mock implements LobbyRepository {}

void main() {
  GetMission usecase;
  MockLobbyRepository mockLobbyRepository;

  setUp(() {
    mockLobbyRepository = MockLobbyRepository();
    usecase = GetMission(mockLobbyRepository);
  });

  final tMissionUid = 'test';
  final tChapterUid = 'test';
  final tMission = Mission(
    missionUid: 'missionUid test',
    chapterUid: 'chapterUid test',
    missionName: 'missionName test',
  );

  test(
    'should get mission from chapter and mission uid using the repository',
    () async {
      // arrange
      when(mockLobbyRepository.getMissionByUids(
        chapterUid: anyNamed('chapterUid'),
        missionUid: anyNamed('missionUid'),
      )).thenAnswer((_) async => Right(tMission));
      // act
      final result = await usecase(GetMissionParams(
        missionUid: tMissionUid,
        chapterUid: tChapterUid,
      ));
      // assert
      expect(result, Right(null));
      verify(mockLobbyRepository.getMissionByUids(
        chapterUid: tChapterUid,
        missionUid: tMissionUid,
      ));
      verifyNoMoreInteractions(mockLobbyRepository);
    },
  );
}
