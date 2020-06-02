import 'package:flutter/material.dart';

/// {@template heading}
/// Support widget that handles styles for our headings.
/// {@endtemplate}
class Heading extends StatelessWidget {
  /// Text value of heading.
  final String text;

  /// {@macro heading}
  Heading({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
      ),
    );
  }
}
