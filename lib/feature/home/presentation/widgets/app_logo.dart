import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets.dart';

/// {@template app_logo}
/// Provides an App logo generation widget.
/// {@endtemplate}
class AppLogo extends StatelessWidget {
  /// Determines if version is used.
  final bool withVersion;

  /// Determines the brightness to generate font with.
  final Brightness brightness;

  /// {@macro app_logo}
  AppLogo({
    Key key,
    this.withVersion = true,
    this.brightness = Brightness.light,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              tr('title'),
              textAlign: TextAlign.end,
              style: GoogleFonts.ubuntu(
                fontSize: 28,
                color: brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            if (withVersion == true) Version(brightness: brightness),
          ],
        ),
      ],
    );
  }
}
