import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login/login_bloc.dart';
import '../bloc/settings/settings_bloc.dart';

/// Provides registration about user
class RegistrationPage extends StatefulWidget {
  /// User uid.
  final String uid;

  /// Takes [uid].
  const RegistrationPage({Key key, this.uid}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  String _selectedLanguageValue;

  String _selectedUsernameValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('title_registration')),
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
                    BlocProvider.of<LoginBloc>(context).add(LoginEvent.register(
                      uid: widget.uid,
                      username: _selectedUsernameValue,
                      language: _selectedLanguageValue,
                    ));

                    BlocProvider.of<SettingsBloc>(context).add(
                      SettingsEvent(
                          language: Locale(
                        _selectedLanguageValue.split('_').first,
                        _selectedLanguageValue.split('_').last,
                      )),
                    );
                  }
                },
                child: Text(tr('btn_finish-registration')),
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
                initialValue: _selectedUsernameValue,
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: tr('label_language'),
                ),
                value: _selectedLanguageValue,
                items:
                    EasyLocalization.of(context).supportedLocales.map((value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguageValue = value;
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
    SchedulerBinding.instance.addPostFrameCallback((_) => _initLocale(context));
  }

  void _initLocale(BuildContext context) {
    setState(() {
      _selectedLanguageValue = EasyLocalization.of(context).locale.toString();
    });
  }
}
