import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/domain/entities/user.dart';
import '../../../../shared/presentation/bloc/user/user_bloc.dart';
import '../bloc/settings/settings_bloc.dart';

/// Page takes care about settings.
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  Locale _selectedLocaleValue;

  String _selectedUsernameValue;

  User _currentUser;

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('title_settings')),
        centerTitle: true,
      ),
      bottomNavigationBar: Builder(
        builder: (innerContext) {
          return Container(
            height: 80,
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    BlocProvider.of<UserBloc>(context).add(
                      UserEvent.setUp(
                        user: _currentUser.copyWith(
                          username: _selectedUsernameValue,
                          language: _selectedLocaleValue.toString(),
                        ),
                      ),
                    );

                    BlocProvider.of<SettingsBloc>(context).add(
                      SettingsEvent(language: _selectedLocaleValue),
                    );
                  }
                },
                child: Text(tr('btn_save')),
              ),
            ),
          );
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        alignment: Alignment.topCenter,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: tr('label_username'),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return tr('valid_empty-text');
                  }

                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedUsernameValue = value;
                  });
                },
              ),
              DropdownButtonFormField<Locale>(
                decoration: InputDecoration(
                  labelText: tr('label_language'),
                ),
                value: _selectedLocaleValue,
                items:
                    EasyLocalization.of(context).supportedLocales.map((value) {
                  return DropdownMenuItem<Locale>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLocaleValue = value;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _initUserData(context));
  }

  void _initUserData(BuildContext context) {
    final currentUser = BlocProvider.of<UserBloc>(context).state.user;

    setState(() {
      _selectedLocaleValue = Locale(
        currentUser.language.split('_').first,
        currentUser.language.split('_').last,
      );
      _selectedUsernameValue = currentUser.username;
      _currentUser = currentUser;
    });

    textController.value = TextEditingValue(text: currentUser.username);
  }
}
