part of 'stats_bloc.dart';

/// Events for game stats.
@freezed
abstract class StatsEvent with _$StatsEvent {
  ///
  const factory StatsEvent.connect() = _Connect;

  ///
  const factory StatsEvent.update({
    @required Game game,
  }) = _Update;

  ///
  const factory StatsEvent.save({@required Game game}) = _Save;
}
