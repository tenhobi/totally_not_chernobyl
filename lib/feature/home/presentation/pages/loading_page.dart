import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants.dart' as c;
import '../widgets/widgets.dart';

/// Shows loading page.
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c.background,
      bottomNavigationBar: Container(
        height: 80,
        child: Center(
          child: FlatButton(
            textColor: Colors.white,
            child: Text(tr('btn_issues')),
            onPressed: () async {
              final url = tr('link_issue');
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url}';
              }
            },
          ),
        ),
      ),
      body: LoadingIndicator(
        color: Colors.white,
      ),
    );
  }
}
