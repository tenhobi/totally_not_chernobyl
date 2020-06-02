import 'dart:async';

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
import '../bloc/manual/manual_bloc.dart';
import '../widgets/action/shake.dart';
import '../widgets/manual/bits.dart';
import '../widgets/manual/button.dart';
import '../widgets/manual/pump.dart';
import '../widgets/manual/sequence.dart';
import '../widgets/manual/slider.dart';

///
class GameManualPage extends StatefulWidget {
  ///
  final String gameUid;

  ///
  final String playerUid;

  ///
  GameManualPage({
    Key key,
    @required this.gameUid,
    @required this.playerUid,
  }) : super(key: key);

  @override
  _GameManualPageState createState() => _GameManualPageState();
}

class _GameManualPageState extends State<GameManualPage> {
  final List<Timer> _timers = [];

  ///
  List<Widget> actionStack = [];

  bool _actionsInitialized = false;

  final _gameRepository = GameRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManualBloc(
        connectToGame: ConnectToGame(_gameRepository),
        gameUid: widget.gameUid,
        playerUid: widget.playerUid,
        saveGame: SaveGame(_gameRepository),
        fetchModules: FetchModules(_gameRepository),
        fetchActions: FetchActions(_gameRepository),
      )..add(ManualEvent.connect()),
      child: BlocConsumer<ManualBloc, ManualState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            data: (game, modules, actions) {
              if (!_actionsInitialized) {
                for (final action in actions) {
                  _startAction(context, action);
                }

                setState(() {
                  _actionsInitialized = true;
                });
              }

              if (game.finished == true) {
                BlocProvider.of<GameBloc>(context).add(GameEvent.toStats());
              }
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => LoadingPage(),
            data: (game, modules, actions) {
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
                  body: Stack(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                        alignment: Alignment.topCenter,
                        child: ListView(
                          children: <Widget>[
                            for (final module in modules)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: _buildModule(context, module),
                              ),
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
    BuildContext context,
    GameModule module,
  ) {
    switch (module.type) {
      case 'button':
        return ButtonModuleWidget(module: module);
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
    BlocProvider.of<ManualBloc>(context).add(
      ManualEvent.save(
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
}
