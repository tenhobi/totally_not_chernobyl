import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/repositories/lobby_repository.dart';
import 'package:totally_not_chernobyl/feature/lobby/domain/usecases/can_connect_to_lobby.dart';

class MockLobbyRepository extends Mock implements LobbyRepository {}

void main() {
  CanConnectToLobby usecase;
  MockLobbyRepository mockLobbyRepository;

  setUp(() {
    mockLobbyRepository = MockLobbyRepository();
    usecase = CanConnectToLobby(mockLobbyRepository);
  });

  final tRoomUid = 'test';

  test(
    'should connect to Lobby using the repository',
    () async {
      // arrange
      when(mockLobbyRepository.canJoinGame(roomUid: anyNamed('roomUid')))
          .thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(CanConnectToLobbyParams(roomUid: tRoomUid));
      // assert
      expect(result, Right(null));
      verify(mockLobbyRepository.canJoinGame(roomUid: tRoomUid));
      verifyNoMoreInteractions(mockLobbyRepository);
    },
  );
}
