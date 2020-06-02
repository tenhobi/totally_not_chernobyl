import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/game_module.dart';
import '../../../../domain/entities/game_module_settings.dart';
import '../../worker/worker_bloc.dart';

part 'pump_bloc.freezed.dart';
part 'pump_event.dart';
part 'pump_state.dart';

///
class PumpModuleBloc extends Bloc<PumpModuleEvent, PumpModuleState> {
  ///
  final WorkerBloc workerBloc;

  PumpModuleSettings _selected;

  ///
  PumpModuleBloc({
    @required this.workerBloc,
  });

  @override
  PumpModuleState get initialState => PumpModuleState.initial();

  @override
  Stream<PumpModuleState> mapEventToState(PumpModuleEvent event) async* {
    yield* event.when(
      setUp: (module) async* {
        final length = module.settings.length;
        final random = Random.secure();
        _selected = module.settings[random.nextInt(length)];

        workerBloc.add(WorkerEvent.completeModule());
        yield PumpModuleState.inProgress(settings: _selected);
      },
      failed: () async* {
        workerBloc.add(WorkerEvent.fail(total: true));
      },
    );
  }
}
