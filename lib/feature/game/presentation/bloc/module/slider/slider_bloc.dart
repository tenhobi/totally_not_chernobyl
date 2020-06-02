import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/game_module.dart';
import '../../../../domain/entities/game_module_settings.dart';
import '../../worker/worker_bloc.dart';

part 'slider_bloc.freezed.dart';
part 'slider_event.dart';
part 'slider_state.dart';

///
class SliderModuleBloc extends Bloc<SliderModuleEvent, SliderModuleState> {
  ///
  final WorkerBloc workerBloc;

  SliderModuleSettings _selected;

  ///
  SliderModuleBloc({
    @required this.workerBloc,
  });

  @override
  SliderModuleState get initialState => SliderModuleState.initial();

  @override
  Stream<SliderModuleState> mapEventToState(SliderModuleEvent event) async* {
    yield* event.when(
      setUp: (module) async* {
        final length = module.settings.length;
        final random = Random.secure();
        _selected = module.settings[random.nextInt(length)];

        yield SliderModuleState.inProgress(settings: _selected);
      },
      attempt: (value) async* {
        if (value == _selected.number) {
          yield SliderModuleState.completed();
          workerBloc.add(WorkerEvent.completeModule());
        } else {
          workerBloc.add(WorkerEvent.fail());
        }
      },
    );
  }
}
