import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

/// Displays current version of app.
class Version extends StatefulWidget {
  /// Determiness dark or light theme.
  final Brightness brightness;

  /// Text that is placed before version.
  final String beforeText;

  /// Takes [brightness] and [beforeText].
  Version({
    Key key,
    this.brightness = Brightness.light,
    this.beforeText = "",
  }) : super(key: key);

  @override
  _VersionState createState() => _VersionState();
}

class _VersionState extends State<Version> {
  PackageInfo _packageInfo = PackageInfo(
    appName: tr('unknown'),
    packageName: tr('unknown'),
    version: tr('unknown'),
    buildNumber: tr('unknown'),
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.beforeText + _packageInfo.version,
      style: TextStyle(
        color:
            widget.brightness == Brightness.light ? Colors.white : Colors.black,
      ),
    );
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();

    setState(() {
      _packageInfo = info;
      print(info.version);
    });
  }
}
