import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/game_module.dart';
import '../../bloc/module/button/button_bloc.dart';
import '../../bloc/worker/worker_bloc.dart';

///
class ButtonModuleWidget extends StatelessWidget {
  /// Game module for button.
  final GameModule module;

  ///
  final int time;

  ///
  ButtonModuleWidget({
    Key key,
    @required this.module,
    @required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _workerBloc = BlocProvider.of<WorkerBloc>(context);

    return BlocProvider(
      create: (context) => ButtonModuleBloc(
        workerBloc: _workerBloc,
      )..add(ButtonModuleEvent.setUp(module: module)),
      child: BlocBuilder<ButtonModuleBloc, ButtonModuleState>(
        builder: (context, state) {
          return state.when(
            initial: () {
              return CircularProgressIndicator();
            },
            inProgress: (settings) {
              return RaisedButton(
                onPressed: () {
                  BlocProvider.of<ButtonModuleBloc>(context)
                      .add(ButtonModuleEvent.attempt(time: time));
                },
                child: Text(settings.text),
                color: _stringToColors(settings.color),
              );
            },
            completed: () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.done),
                  Text(tr('completed')),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Color _stringToColors(String color) {
    switch (color) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
