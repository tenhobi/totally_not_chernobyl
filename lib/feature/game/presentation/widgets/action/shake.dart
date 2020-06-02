import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

import '../../../../../constants.dart' as c;

///
class ShakeActionWidget extends StatefulWidget {
  /// Function to call after action completed.
  final Function(ShakeActionWidget action) onComplete;

  ///
  ShakeActionWidget({
    Key key,
    @required this.onComplete,
  }) : super(key: key);

  @override
  _ShakeActionWidgetState createState() => _ShakeActionWidgetState();
}

class _ShakeActionWidgetState extends State<ShakeActionWidget> {
  ShakeDetector detector;

  @override
  void initState() {
    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        widget.onComplete(widget);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: c.background,
      child: Center(
        child: Text(
          tr('action_shake'),
          style: TextStyle(fontSize: 26),
        ),
      ),
    );
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }
}
