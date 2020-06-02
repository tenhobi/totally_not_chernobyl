import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/game_module.dart';

///
class PumpModuleWidget extends StatelessWidget {
  /// Game module for button.
  final GameModule module;

  ///
  PumpModuleWidget({
    Key key,
    @required this.module,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Pump',
            style: TextStyle(fontSize: 28),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              tr('solution_pump'),
            ),
          ),
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
      ],
    );
  }
}
