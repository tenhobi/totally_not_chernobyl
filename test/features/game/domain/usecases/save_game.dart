import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/feature/game/domain/entities/game.dart';
import 'package:totally_not_chernobyl/feature/game/domain/repositories/game_repository.dart';
import 'package:totally_not_chernobyl/feature/game/domain/usecases/save_game.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  SaveGame usecase;
  MockGameRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockGameRepository();
    usecase = SaveGame(mockAuthRepository);
  });

  final tGameUid = '123';
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

  test(
    'should get game by uid from the repository',
    () async {
      // arrange
      when(mockAuthRepository.saveGame(
        game: anyNamed('game'),
        gameUid: anyNamed('gameUid'),
      )).thenAnswer((_) async => Right(true));
      // act
      final result = await usecase(SaveGameParams(
        game: tGame,
        gameUid: tGameUid,
      ));
      // assert
      expect(result, Stream.fromIterable([Right(tGame)]));
      verify(mockAuthRepository.saveGame(game: tGame, gameUid: tGameUid));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
