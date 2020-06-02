import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/game_module.dart';
import '../../../../domain/entities/game_module_settings.dart';
import '../../worker/worker_bloc.dart';

part 'bits_bloc.freezed.dart';
part 'bits_event.dart';
part 'bits_state.dart';

///
class BitsModuleBloc extends Bloc<BitsModuleEvent, BitsModuleState> {
  ///
  final WorkerBloc workerBloc;

  BitsModuleSettings _selected;

  ///
  BitsModuleBloc({
    @required this.workerBloc,
  });

  @override
  BitsModuleState get initialState => BitsModuleState.initial();

  @override
  Stream<BitsModuleState> mapEventToState(BitsModuleEvent event) async* {
    yield* event.when(
      setUp: (module) async* {
        final length = module.settings.length;
        final random = Random.secure();
        _selected = module.settings[random.nextInt(length)];

        yield BitsModuleState.inProgress(settings: _selected);
      },
      attempt: (value) async* {
        if (value == _selected.number) {
          yield BitsModuleState.completed();
          workerBloc.add(WorkerEvent.completeModule());
        } else {
          workerBloc.add(WorkerEvent.fail());
        }
      },
    );
  }
}
