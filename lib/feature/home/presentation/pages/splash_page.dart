import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants.dart' as c;
import '../widgets/widgets.dart';

/// Creates simple splash page with indicator.
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: c.background,
      ),
      child: Scaffold(
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
        body: Container(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 150),
              ),
              AppLogo(),
              Expanded(
                child: LoadingIndicator(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
