import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/game_module.dart';
import '../../bloc/module/bits/bits_bloc.dart';
import '../../bloc/worker/worker_bloc.dart';

///
class BitsModuleWidget extends StatefulWidget {
  /// Game module for button.
  final GameModule module;

  ///
  BitsModuleWidget({
    Key key,
    @required this.module,
  }) : super(key: key);

  @override
  _BitsModuleWidgetState createState() => _BitsModuleWidgetState();
}

class _BitsModuleWidgetState extends State<BitsModuleWidget> {
  int sliderValue;

  List<bool> pressed = List.generate(4, (index) => false);

  @override
  Widget build(BuildContext context) {
    final _workerBloc = BlocProvider.of<WorkerBloc>(context);

    return BlocProvider(
      create: (context) => BitsModuleBloc(
        workerBloc: _workerBloc,
      )..add(BitsModuleEvent.setUp(module: widget.module)),
      child: BlocBuilder<BitsModuleBloc, BitsModuleState>(
        builder: (context, state) {
          return state.when(
            initial: () {
              return CircularProgressIndicator();
            },
            inProgress: (settings) {
              return Column(
                children: <Widget>[
                  Text(settings.text),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (var bit = 0; bit < pressed.length; bit++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              pressed[bit] = !pressed[bit];
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              color: pressed[bit] ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {
                      BlocProvider.of<BitsModuleBloc>(context).add(
                          BitsModuleEvent.attempt(value: _bitsToInt(pressed)));
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

  int _bitsToInt(List<bool> bits) {
    var number = 0;
    for (var i = bits.length - 1; i >= 0; i--) {
      if (bits[bits.length - 1 - i]) {
        number += pow(2, i);
      }
    }
    return number;
  }
}
