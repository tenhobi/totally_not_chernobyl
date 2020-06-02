import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/game_module.dart';
import '../../../domain/entities/game_module_settings.dart';

///
class BitsModuleWidget extends StatelessWidget {
  /// Game module for button.
  final GameModule module;

  ///
  BitsModuleWidget({
    Key key,
    @required this.module,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = <BitsModuleSettings>[];

    for (var module in module.settings) {
      list.add(module);
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Bits',
            style: TextStyle(fontSize: 28),
          ),
        ),
        for (final module in list)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                tr('solution_bits', args: [
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
