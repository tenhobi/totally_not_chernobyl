import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/game_module.dart';
import '../../../domain/entities/game_module_settings.dart';

///
class ButtonModuleWidget extends StatelessWidget {
  /// Game module for button.
  final GameModule module;

  ///
  ButtonModuleWidget({
    Key key,
    @required this.module,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = <ButtonModuleSettings>[];

    for (var module in module.settings) {
      list.add(module);
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Button',
            style: TextStyle(fontSize: 28),
          ),
        ),
        for (final module in list)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                tr('solution_button', args: [
                  module.color,
                  module.text,
                  module.number.toString(),
                ]),
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 10),
          ),
      ],
    );
  }
}
