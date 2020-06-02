import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/repositories/lobby_repository.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/usecases/create_lobby.dart';
import 'package:totally_not_chernobyl/shared/domain/entities/lobby.dart';

class MockLobbyRepository extends Mock implements LobbyRepository {}

void main() {
  CreateLobby usecase;
  MockLobbyRepository mockLobbyRepository;

  setUp(() {
    mockLobbyRepository = MockLobbyRepository();
    usecase = CreateLobby(mockLobbyRepository);
  });

  final tRoomUid = 'test';
  final tCreatorUid = 'test';
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
    'should create lobby and return lobby stream using the repository',
    () async {
      // arrange
      when(mockLobbyRepository.createLobby(
        roomUid: anyNamed('roomUid'),
        creatorUid: anyNamed('creatorUid'),
      )).thenAnswer((_) async => Right(true));
      when(mockLobbyRepository.getLobbyStream(
        roomUid: anyNamed('roomUid'),
      )).thenAnswer((_) => Stream.fromIterable([Right(tLobby)]));
      // act
      final result = await usecase(CreateLobbyParams(
        roomUid: tRoomUid,
        creatorUid: tCreatorUid,
      ));
      // assert
      expect(result, Stream.fromIterable([Right(tLobby)]));
      verify(mockLobbyRepository.joinGame(
        roomUid: tRoomUid,
        joinedUid: tCreatorUid,
      ));
      verify(mockLobbyRepository.getLobbyStream(
        roomUid: tRoomUid,
      ));
      verifyNoMoreInteractions(mockLobbyRepository);
    },
  );
}
