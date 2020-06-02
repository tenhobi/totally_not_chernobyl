import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/repositories/lobby_repository.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/usecases/update_lobby.dart';
import 'package:totally_not_chernobyl/shared/domain/entities/lobby.dart';

class MockLobbyRepository extends Mock implements LobbyRepository {}

void main() {
  UpdateLobby usecase;
  MockLobbyRepository mockLobbyRepository;

  setUp(() {
    mockLobbyRepository = MockLobbyRepository();
    usecase = UpdateLobby(mockLobbyRepository);
  });

  final tRoomUid = 'test';
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
    'should update Lobby using the repository',
    () async {
      // arrange
      when(mockLobbyRepository.updateLobby(
        lobby: anyNamed('lobby'),
        roomUid: anyNamed('roomUid'),
      )).thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(UpdateLobbyParams(
        roomUid: tRoomUid,
        lobby: tLobby,
      ));
      // assert
      expect(result, Right(true));
      verify(mockLobbyRepository.updateLobby(
        lobby: tLobby,
        roomUid: tRoomUid,
      ));
      verifyNoMoreInteractions(mockLobbyRepository);
    },
  );
}
