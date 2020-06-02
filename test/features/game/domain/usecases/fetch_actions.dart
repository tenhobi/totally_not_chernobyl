import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:totally_not_chernobyl/feature/game/domain/entities/game.dart';
import 'package:totally_not_chernobyl/feature/game/domain/entities/game_action.dart';
import 'package:totally_not_chernobyl/feature/game/domain/repositories/game_repository.dart';
import 'package:totally_not_chernobyl/feature/game/domain/usecases/fetch_actions.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  FetchActions usecase;
  MockGameRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockGameRepository();
    usecase = FetchActions(mockAuthRepository);
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
  final tGameAction = GameAction.shake(
    time: 1,
  );

  test(
    'should get game by uid from the repository',
    () async {
      // arrange
      when(mockAuthRepository.getActions(
        game: anyNamed('game'),
      )).thenAnswer((_) async => Right([tGameAction]));
      // act
      final result = await usecase(FetchActionsParams(game: tGame));
      // assert
      expect(result, Right([tGameAction]));
      verify(mockAuthRepository.getActions(game: tGame));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
