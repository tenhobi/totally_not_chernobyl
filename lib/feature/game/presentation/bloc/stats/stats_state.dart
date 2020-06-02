part of 'stats_bloc.dart';

/// States for game stats.
@freezed
abstract class StatsState with _$StatsState {
  ///
  const factory StatsState.initial() = _Initial;

  ///
  const factory StatsState.data({
    @required Game game,
  }) = _Data;
}
