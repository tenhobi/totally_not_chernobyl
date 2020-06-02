import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/presentation/bloc/user/user_bloc.dart';
import '../widgets/widgets.dart';

/// Displays information about current user.
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);

    return BlocBuilder<UserBloc, UserState>(
      bloc: _userBloc..add(UserEvent.fetch()),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(tr('title_profile')),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        state.user.photoUrl,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                      ),
                      Heading(
                          text: tr(
                        'user-name',
                        args: [state.user.username],
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 40),
                ),
                Heading(text: tr('statistics')),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(tr('stats_game-count',
                    args: [state.user.gamesCount.toString()])),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                Text(tr('stats_game-win', args: [
                  if (state.user.gamesCount == 0)
                    '0'
                  else
                    (100 * (state.user.winGamesCount) / (state.user.gamesCount))
                        .toStringAsPrecision(2)
                ])),
              ],
            ),
          ),
        );
      },
    );
  }
}
