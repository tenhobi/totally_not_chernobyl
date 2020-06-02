import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/repositories/lobby_repository.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/usecases/connect_to_lobby.dart';
import 'package:totally_not_chernobyl/shared/domain/entities/lobby.dart';

class MockLobbyRepository extends Mock implements LobbyRepository {}

void main() {
  ConnectToLobby usecase;
  MockLobbyRepository mockLobbyRepository;

  setUp(() {
    mockLobbyRepository = MockLobbyRepository();
    usecase = ConnectToLobby(mockLobbyRepository);
  });

  final tRoomUid = 'test';
  final tJoinedUid = 'test';
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
    'should join to game and return game stream using the repository',
    () async {
      // arrange
      when(mockLobbyRepository.joinGame(
        roomUid: anyNamed('roomUid'),
        joinedUid: anyNamed('joinedUid'),
      )).thenAnswer((_) async => Right(true));
      when(mockLobbyRepository.getLobbyStream(
        roomUid: anyNamed('roomUid'),
      )).thenAnswer((_) => Stream.fromIterable([Right(tLobby)]));
      // act
      final result = await usecase(ConnectToLobbyParams(
        roomUid: tRoomUid,
        joinedUid: tJoinedUid,
      ));
      // assert
      expect(result, Stream.fromIterable([Right(tLobby)]));
      verify(mockLobbyRepository.joinGame(
        roomUid: tRoomUid,
        joinedUid: tJoinedUid,
      ));
      verify(mockLobbyRepository.getLobbyStream(
        roomUid: tRoomUid,
      ));
      verifyNoMoreInteractions(mockLobbyRepository);
    },
  );
}
