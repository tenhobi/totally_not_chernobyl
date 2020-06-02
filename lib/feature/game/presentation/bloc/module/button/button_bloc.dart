import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/entities/game_module.dart';
import '../../../../domain/entities/game_module_settings.dart';
import '../../worker/worker_bloc.dart';

part 'button_bloc.freezed.dart';
part 'button_event.dart';
part 'button_state.dart';

///
class ButtonModuleBloc extends Bloc<ButtonModuleEvent, ButtonModuleState> {
  ///
  final WorkerBloc workerBloc;

  ButtonModuleSettings _selected;

  ///
  ButtonModuleBloc({
    @required this.workerBloc,
  });

  @override
  ButtonModuleState get initialState => ButtonModuleState.initial();

  @override
  Stream<ButtonModuleState> mapEventToState(ButtonModuleEvent event) async* {
    yield* event.when(
      setUp: (module) async* {
        final length = module.settings.length;
        final random = Random.secure();
        _selected = module.settings[random.nextInt(length)];

        yield ButtonModuleState.inProgress(settings: _selected);
      },
      attempt: (time) async* {
        if (_numberToCiphersList(time).contains(_selected.number)) {
          yield ButtonModuleState.completed();
          workerBloc.add(WorkerEvent.completeModule());
        } else {
          workerBloc.add(WorkerEvent.fail());
        }
      },
    );
  }

  List<int> _numberToCiphersList(int number) {
    final charList = number.toString().split('');
    final cipherList = <int>[];
    for (var char in charList) {
      cipherList.add(int.parse(char));
    }
    return cipherList;
  }
}
