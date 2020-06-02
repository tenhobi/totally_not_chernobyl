import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/feature/game/domain/entities/game.dart';
import 'package:totally_not_chernobyl/feature/game/domain/entities/game_module.dart';
import 'package:totally_not_chernobyl/feature/game/domain/entities/game_module_settings.dart';
import 'package:totally_not_chernobyl/feature/game/domain/repositories/game_repository.dart';
import 'package:totally_not_chernobyl/feature/game/domain/usecases/fetch_modules.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  FetchModules usecase;
  MockGameRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockGameRepository();
    usecase = FetchModules(mockAuthRepository);
  });

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
  final tGameModule = GameModule(
    type: 'type test',
    times: 1,
    settings: <GameModuleSettings>[],
  );

  test(
    'should get game by uid from the repository',
    () async {
      // arrange
      when(mockAuthRepository.getModules(
        game: anyNamed('game'),
      )).thenAnswer((_) async => Right([tGameModule]));
      // act
      final result = await usecase(FetchModulesParams(game: tGame));
      // assert
      expect(result, Right([tGameModule]));
      verify(mockAuthRepository.getModules(game: tGame));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
