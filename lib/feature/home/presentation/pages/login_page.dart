import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants.dart' as c;
import '../bloc/login/login_bloc.dart';
import '../widgets/widgets.dart';

/// Page that handles login of unsigned user.
class LoginPage extends StatelessWidget {
  /// Error message.
  final String error;

  /// Takes [error] as optional parameter.
  const LoginPage({Key key, this.error}) : super(key: key);

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        BlocProvider.of<LoginBloc>(context)
                            .add(LoginEvent.login());
                      },
                      child: Text(tr('btn_google-signin')),
                    ),
                    if (error != null) ...[
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                      ),
                      Text(error),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
