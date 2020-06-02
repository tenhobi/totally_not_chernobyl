import 'package:flutter/material.dart';

/// {@template loading_indicator}
/// Support widget that creates an centered indicator
/// and uses [color] as background of the active part.
/// {@endtemplate}
class LoadingIndicator extends StatelessWidget {
  /// Color of active part.
  final Color color;

  /// {@macro loading_indicator}
  LoadingIndicator({this.color = Colors.red});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
