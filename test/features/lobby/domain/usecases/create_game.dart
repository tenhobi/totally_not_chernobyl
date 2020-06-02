import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/repositories/lobby_repository.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/usecases/can_connect_to_lobby.dart';
import 'package:totally_not_chernobyl/shared/domain/entities/lobby.dart';

class MockLobbyRepository extends Mock implements LobbyRepository {}

void main() {
  CanConnectToLobby usecase;
  MockLobbyRepository mockLobbyRepository;

  setUp(() {
    mockLobbyRepository = MockLobbyRepository();
    usecase = CanConnectToLobby(mockLobbyRepository);
  });

  final tRoomUid = 'test';
  final tMissionName = 'test';
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

  test(
    'should create game using the repository',
    () async {
      // arrange
      when(mockLobbyRepository.createGame(
        lobby: anyNamed('lobby'),
        missionName: anyNamed('missionName'),
      )).thenAnswer((_) async => Right(tRoomUid));
      // acta
      final result = await usecase(CanConnectToLobbyParams(roomUid: tRoomUid));
      // assert
      expect(result, Right(null));
      verify(mockLobbyRepository.createGame(
        lobby: tLobby,
        missionName: tMissionName,
      ));
      verifyNoMoreInteractions(mockLobbyRepository);
    },
  );
}
