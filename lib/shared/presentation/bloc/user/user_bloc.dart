import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../feature/home/presentation/bloc/authentication/authentication_bloc.dart';
import '../../../../feature/home/presentation/bloc/settings/settings_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/get_user_by_uid.dart';
import '../../../domain/usecases/save_user.dart';

part 'user_bloc.freezed.dart';
part 'user_event.dart';
part 'user_state.dart';

/// {@template user_bloc}
///
/// {@endtemplate}
class UserBloc extends Bloc<UserEvent, UserState> {
  ///
  AuthenticationBloc authenticationBloc;

  ///
  SettingsBloc settingsBloc;

  ///
  GetUserByUid getUserByUid;

  ///
  SaveUser saveUser;

  /// {@macro user_bloc}
  UserBloc({
    @required this.authenticationBloc,
    @required this.settingsBloc,
    @required this.getUserByUid,
    @required this.saveUser,
  });

  @override
  UserState get initialState =>
      UserState(user: User(language: '', photoUrl: '', username: ''));

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    yield* event.when(
      setUp: (user) async* {
        yield* authenticationBloc.state.maybeWhen(
          authenticated: (uid) async* {
            final savedUser =
                await saveUser(SaveUserParams(uid: uid, user: user));

            yield* savedUser.fold((l) => null, (r) async* {
              settingsBloc.add(
                SettingsEvent(
                  language: Locale(
                    user.language.split('_').first,
                    user.language.split('_').last,
                  ),
                ),
              );
              yield UserState(user: user);
            });
          },
          orElse: () async* {},
        );
      },
      fetch: () async* {
        yield* authenticationBloc.state.maybeWhen(
          authenticated: (uid) async* {
            final user = await getUserByUid(GetUserByUidParams(uid: uid));
            yield* user.fold((l) async* {}, (user) async* {
              settingsBloc.add(
                SettingsEvent(
                  language: Locale(
                    user.language.split('_').first,
                    user.language.split('_').last,
                  ),
                ),
              );
              yield UserState(user: user);
            });
          },
          orElse: () async* {},
        );
      },
    );
  }
}
