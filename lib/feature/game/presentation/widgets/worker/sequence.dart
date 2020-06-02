import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/game_module.dart';
import '../../bloc/module/sequence/sequence_bloc.dart';
import '../../bloc/worker/worker_bloc.dart';

///
class SequenceModuleWidget extends StatefulWidget {
  /// Game module for sequence.
  final GameModule module;

  ///
  SequenceModuleWidget({
    Key key,
    @required this.module,
  }) : super(key: key);

  @override
  _SequenceModuleWidgetState createState() => _SequenceModuleWidgetState();
}

class _SequenceModuleWidgetState extends State<SequenceModuleWidget> {
  int sliderValue;

  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    final _workerBloc = BlocProvider.of<WorkerBloc>(context);

    return BlocProvider(
      create: (context) => SequenceModuleBloc(
        workerBloc: _workerBloc,
      )..add(SequenceModuleEvent.setUp(module: widget.module)),
      child: BlocBuilder<SequenceModuleBloc, SequenceModuleState>(
        builder: (context, state) {
          return state.when(
            initial: () {
              return CircularProgressIndicator();
            },
            inProgress: (settings) {
              return Column(
                children: <Widget>[
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      for (final char in settings.all)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: selected.contains(char)
                                ? null
                                : () {
                                    selected.add(char);
                                  },
                            child: Container(
                              width: 50,
                              height: 50,
                              color: selected.contains(char)
                                  ? Colors.blue
                                  : Colors.grey,
                              child: Center(
                                child: Text(char),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {
                      BlocProvider.of<SequenceModuleBloc>(context)
                          .add(SequenceModuleEvent.attempt(value: selected));
                      selected = [];
                    },
                    child: Text(tr('btn_attempt')),
                  ),
                ],
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
}
