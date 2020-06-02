import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/game_module.dart';
import '../../bloc/module/pump/pump_bloc.dart';
import '../../bloc/worker/worker_bloc.dart';

///
class PumpModuleWidget extends StatefulWidget {
  /// Game module for button.
  final GameModule module;

  ///
  PumpModuleWidget({
    Key key,
    @required this.module,
  }) : super(key: key);

  @override
  _PumpModuleWidgetState createState() => _PumpModuleWidgetState();
}

class _PumpModuleWidgetState extends State<PumpModuleWidget> {
  int sliderValue;

  int _currentTime;

  Timer _timer;

  @override
  Widget build(BuildContext context) {
    final _workerBloc = BlocProvider.of<WorkerBloc>(context);

    return BlocProvider(
      create: (context) => PumpModuleBloc(
        workerBloc: _workerBloc,
      )..add(PumpModuleEvent.setUp(module: widget.module)),
      child: BlocConsumer<PumpModuleBloc, PumpModuleState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            inProgress: (settings) {
              if (_timer == null) {
                _currentTime = settings.time;
                _startTimer(context);
              }
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () {
              return CircularProgressIndicator();
            },
            inProgress: (settings) {
              if (_currentTime == null) {
                return CircularProgressIndicator();
              }

              return Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentTime = settings.time;
                      });
                    },
                    child: Container(
                      color: Colors.green,
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          _currentTime.toString(),
                          style: TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(BuildContext context) {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (timer) => setState(
        () {
          if (_currentTime <= 0) {
            timer.cancel();
            final _bloc = BlocProvider.of<PumpModuleBloc>(context);

            try {
              _bloc.add(PumpModuleEvent.failed());
            }
            // ignore: avoid_catches_without_on_clauses
            catch (_) {}
          } else {
            _currentTime--;
          }
        },
      ),
    );
  }
}
