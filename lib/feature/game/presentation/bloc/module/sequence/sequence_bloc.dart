import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/game_module.dart';
import '../../../../domain/entities/game_module_settings.dart';
import '../../worker/worker_bloc.dart';

part 'sequence_bloc.freezed.dart';
part 'sequence_event.dart';
part 'sequence_state.dart';

///
class SequenceModuleBloc
    extends Bloc<SequenceModuleEvent, SequenceModuleState> {
  ///
  final WorkerBloc workerBloc;

  SequenceModuleSettings _selected;

  ///
  SequenceModuleBloc({
    @required this.workerBloc,
  });

  @override
  SequenceModuleState get initialState => SequenceModuleState.initial();

  @override
  Stream<SequenceModuleState> mapEventToState(
      SequenceModuleEvent event) async* {
    yield* event.when(
      setUp: (module) async* {
        final length = module.settings.length;
        final random = Random.secure();
        _selected = module.settings[random.nextInt(length)];

        yield SequenceModuleState.inProgress(settings: _selected);
      },
      attempt: (value) async* {
        if (_compare(value, _selected.select)) {
          yield SequenceModuleState.completed();
          workerBloc.add(WorkerEvent.completeModule());
        } else {
          workerBloc.add(WorkerEvent.fail());
        }
      },
    );
  }

  bool _compare(List<String> original, List<String> attempted) {
    return original.join(',') == attempted.join(',');
  }
}
