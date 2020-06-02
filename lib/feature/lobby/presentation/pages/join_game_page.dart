import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/lobby/lobby_bloc.dart';

///
class JoinGamePage extends StatefulWidget {
  ///
  final bool failed;

  ///
  JoinGamePage({Key key, this.failed = false}) : super(key: key);

  @override
  _JoinGamePageState createState() => _JoinGamePageState();
}

class _JoinGamePageState extends State<JoinGamePage> {
  final _formKey = GlobalKey<FormState>();

  String _gameKeyValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('title_lobby-join')),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        alignment: Alignment.topCenter,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _gameKeyValue,
                decoration: InputDecoration(
                  labelText: tr('text_lobby-join-key'),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return tr('valid_empty-text');
                  }

                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _gameKeyValue = value;
                  });
                },
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    BlocProvider.of<LobbyBloc>(context).add(
                      LobbyEvent.connect(roomId: _gameKeyValue),
                    );
                  }
                },
                child: Text(tr('text_lobby-join')),
              ),
              if (widget.failed) Text(tr('text_lobby-join-failed')),
            ],
          ),
        ),
      ),
    );
  }
}
