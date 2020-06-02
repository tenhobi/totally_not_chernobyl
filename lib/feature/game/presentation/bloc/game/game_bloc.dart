import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_bloc.freezed.dart';
part 'game_event.dart';
part 'game_state.dart';

///
class GameBloc extends Bloc<GameEvent, GameState> {
  @override
  GameState get initialState => GameState.initial();

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    yield* event.when(
      toWorker: () async* {
        yield GameState.worker();
      },
      toManual: () async* {
        yield GameState.manual();
      },
      toStats: () async* {
        yield GameState.stats();
      },
    );
  }
}
