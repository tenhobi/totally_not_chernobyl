import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/presentation/bloc/user/user_bloc.dart';
import '../../../lobby/presentation/pages/page.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/settings/settings_bloc.dart';
import '../widgets/widgets.dart';
import 'about_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

/// Menu that redirects to other pages like playing game, settings, info etc.
class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);
    final _authBloc = BlocProvider.of<AuthenticationBloc>(context);
    final _settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider.value(
                  value: _userBloc,
                  child: BlocProvider.value(
                    value: _authBloc,
                    child: LobbyPage(
                      isGameCreated: true,
                    ),
                  ),
                );
              },
            ),
          );
        },
        icon: Icon(Icons.add),
        label: Text(tr('btn_new-game')),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6.0,
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(
            side: BorderSide(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.group_add,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider.value(
                          value: _userBloc,
                          child: BlocProvider.value(
                            value: _authBloc,
                            child: LobbyPage(
                              isGameCreated: false,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: () async {
                  _authBloc.add(AuthenticationEvent.loggedOut());
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          bottom: 50,
        ),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 150),
            ),
            AppLogo(brightness: Brightness.dark),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  buttonTheme: ButtonThemeData(
                    buttonColor: Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(tr('btn_profile')),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider.value(
                                value: _userBloc,
                                child: ProfilePage(),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    RaisedButton(
                      child: Text(tr('btn_about-app')),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AboutPage();
                            },
                          ),
                        );
                      },
                    ),
                    RaisedButton(
                      child: Text(tr('btn_settings')),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider.value(
                                value: _settingsBloc,
                                child: BlocProvider.value(
                                  value: _userBloc,
                                  child: SettingsPage(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
