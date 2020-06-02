import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/widgets.dart';

/// Shows information about the game.
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('title_about')),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Heading(text: tr('title')),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Version(
              beforeText: "${tr("version")} ",
              brightness: Brightness.dark,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Text(tr('created')),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                final url = tr('link_repo');
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url}';
                }
              },
              child: Text(tr('link-to-project')),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Text(tr('about')),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
            ),
            RaisedButton(
              onPressed: () {
                showLicensePage(context: context);
              },
              child: Text(tr('btn_licenses')),
            ),
            RaisedButton(
              onPressed: () async {
                final url = tr('link_issue');
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url}';
                }
              },
              child: Text(tr('btn_issues')),
            ),
          ],
        ),
      ),
    );
  }
}
