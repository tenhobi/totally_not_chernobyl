import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

///
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        child: Center(
          child: FlatButton(
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
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
