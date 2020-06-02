import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/presentation/pages/loading_page.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/game_action.dart';
import '../../domain/entities/game_module.dart';
import '../../domain/usecases/connect_to_game.dart';
import '../../domain/usecases/fetch_actions.dart';
import '../../domain/usecases/fetch_modules.dart';
import '../../domain/usecases/save_game.dart';
import '../bloc/game/game_bloc.dart';
import '../bloc/worker/worker_bloc.dart';
import '../widgets/action/shake.dart';
import '../widgets/worker/bits.dart';
import '../widgets/worker/button.dart';
import '../widgets/worker/pump.dart';
import '../widgets/worker/sequence.dart';
import '../widgets/worker/slider.dart';

///
class GameWorkerPage extends StatefulWidget {
  ///
  final String gameUid;

  ///
  final String playerUid;

  ///
  GameWorkerPage({
    Key key,
    @required this.gameUid,
    @required this.playerUid,
  }) : super(key: key);

  @override
  _GameWorkerPageState createState() => _GameWorkerPageState();
}

class _GameWorkerPageState extends State<GameWorkerPage> {
  final _gameRepository = GameRepositoryImpl();

  int _currentTime;

  final List<Timer> _timers = [];

  List<Widget> actionStack = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkerBloc(
        connectToGame: ConnectToGame(_gameRepository),
        gameUid: widget.gameUid,
        playerUid: widget.playerUid,
        saveGame: SaveGame(_gameRepository),
        fetchModules: FetchModules(_gameRepository),
        fetchActions: FetchActions(_gameRepository),
      )..add(WorkerEvent.connect()),
      child: BlocConsumer<WorkerBloc, WorkerState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            data: (game, modules, modulesLeft, errorsLeft, actions) {
              // initial load time
              if (_currentTime == null) {
                setState(() {
                  _currentTime = game.time;
                });

                _startTimer(context);

                for (final action in actions) {
                  _startAction(context, action);
                }
              }

              // finish game
              if (game.finished == true) {
                BlocProvider.of<GameBloc>(context).add(GameEvent.toStats());
              } else if (modulesLeft == 0) {
                BlocProvider.of<WorkerBloc>(context).add(
                  WorkerEvent.save(
                    game: game.copyWith(
                      finished: true,
                      endTime: _currentTime,
                      modulesLeft: 0,
                    ),
                  ),
                );
              }
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => LoadingPage(),
            data: (game, modules, modulesLeft, errorsLeft, actions) {
              return WillPopScope(
                onWillPop: () async {
                  _onWillPop(context, game);
                  return false;
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(game.missionName),
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        _onWillPop(context, game);
                      },
                    ),
                  ),
                  bottomNavigationBar: BottomAppBar(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _currentTime.toString(),
                            style: TextStyle(fontSize: 36),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              tr('text_game-info', args: [
                                (game.errors - errorsLeft).toString(),
                                game.errors.toString(),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: Stack(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                        alignment: Alignment.topCenter,
                        child: ListView(
                          children: <Widget>[
                            ...[
                              for (final module in modules)
                                for (final _ in List.generate(
                                    module.times, (index) => module))
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 50),
                                    child: _buildModule(
                                        context, module, _currentTime),
                                  ),
                            ]
                          ],
                        ),
                      ),
                      if (actionStack.isNotEmpty)
                        for (final action in actionStack) action,
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (var timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  Widget _buildModule(
      BuildContext context, GameModule module, int currentTime) {
    switch (module.type) {
      case 'button':
        return ButtonModuleWidget(module: module, time: currentTime);
      case 'slider':
        return SliderModuleWidget(module: module);
      case 'sequence':
        return SequenceModuleWidget(module: module);
      case 'bits':
        return BitsModuleWidget(module: module);
      case 'pump':
        return PumpModuleWidget(module: module);
    }

    return Text('error');
  }

  void _onWillPop(BuildContext context, Game game) {
    BlocProvider.of<WorkerBloc>(context).add(
      WorkerEvent.save(
        game: game.copyWith(
          finished: true,
          endTime: null,
        ),
      ),
    );
  }

  void _startAction(BuildContext context, GameAction action) {
    final time = Duration(seconds: action.time);

    final timer = Timer.periodic(
      time,
      (timer) {
        if (action is ShakeAction) {
          final actionWidget = ShakeActionWidget(
            onComplete: (action) {
              setState(() {
                actionStack.remove(action);
              });
            },
          );

          setState(() {
            actionStack.add(actionWidget);
          });
        }
      },
    );
    _timers.add(timer);
  }

  void _startTimer(BuildContext context) {
    const oneSec = Duration(seconds: 1);
    var timer = Timer.periodic(
      oneSec,
      (timer) {
        if (_currentTime <= 0) {
          timer.cancel();

          final _bloc = BlocProvider.of<WorkerBloc>(context);

          _bloc.state.when(
            initial: () {},
            data: (game, modules, modulesLeft, errorsLeft, actions) {
              BlocProvider.of<WorkerBloc>(context).add(
                WorkerEvent.save(
                  game: game.copyWith(
                    finished: true,
                    endTime: 0,
                    modulesLeft: modulesLeft,
                  ),
                ),
              );
            },
          );
        } else {
          setState(() {
            _currentTime--;
          });
        }
      },
    );

    _timers.add(timer);
  }
}
