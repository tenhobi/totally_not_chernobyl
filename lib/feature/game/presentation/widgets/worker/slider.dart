import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/game_module.dart';
import '../../bloc/module/slider/slider_bloc.dart';
import '../../bloc/worker/worker_bloc.dart';

///
class SliderModuleWidget extends StatefulWidget {
  /// Game module for button.
  final GameModule module;

  ///
  SliderModuleWidget({
    Key key,
    @required this.module,
  }) : super(key: key);

  @override
  _SliderModuleWidgetState createState() => _SliderModuleWidgetState();
}

class _SliderModuleWidgetState extends State<SliderModuleWidget> {
  int sliderValue;

  @override
  Widget build(BuildContext context) {
    final _workerBloc = BlocProvider.of<WorkerBloc>(context);

    return BlocProvider(
      create: (context) => SliderModuleBloc(
        workerBloc: _workerBloc,
      )..add(SliderModuleEvent.setUp(module: widget.module)),
      child: BlocBuilder<SliderModuleBloc, SliderModuleState>(
        builder: (context, state) {
          return state.when(
            initial: () {
              return CircularProgressIndicator();
            },
            inProgress: (settings) {
              return Column(
                children: <Widget>[
                  Text(settings.max.toString()),
                  Slider(
                      label: sliderValue.toString(),
                      divisions: settings.max - 1,
                      min: 1,
                      value: sliderValue?.toDouble() ?? 1,
                      max: settings.max.toDouble(),
                      onChanged: (value) {
                        setState(
                          () {
                            sliderValue = value.toInt();
                          },
                        );
                      }),
                  RaisedButton(
                    onPressed: () {
                      BlocProvider.of<SliderModuleBloc>(context)
                          .add(SliderModuleEvent.attempt(value: sliderValue));
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
