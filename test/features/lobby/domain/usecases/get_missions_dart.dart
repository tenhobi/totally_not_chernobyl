import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/core/usecases/usecase.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/entities/mission.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/repositories/lobby_repository.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/usecases/get_missions.dart';

class MockLobbyRepository extends Mock implements LobbyRepository {}

void main() {
  GetMissions usecase;
  MockLobbyRepository mockLobbyRepository;

  setUp(() {
    mockLobbyRepository = MockLobbyRepository();
    usecase = GetMissions(mockLobbyRepository);
  });

  final tMission = Mission(
    missionUid: 'missionUid test',
    chapterUid: 'chapterUid test',
    missionName: 'missionName test',
  );

  test(
    'should get missions from chapter and mission uid using the repository',
    () async {
      // arrange
      when(mockLobbyRepository.fetchMissions())
          .thenAnswer((_) async => Right([tMission]));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right([tMission]));
      verify(mockLobbyRepository.fetchMissions());
      verifyNoMoreInteractions(mockLobbyRepository);
    },
  );
}
