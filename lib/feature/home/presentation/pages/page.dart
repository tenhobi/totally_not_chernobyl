import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants.dart' as c;
import '../../../../shared/data/repositories/user_repository_impl.dart';
import '../../../../shared/domain/usecases/get_user_by_uid.dart';
import '../../../../shared/domain/usecases/is_user_registered.dart';
import '../../../../shared/domain/usecases/register_user.dart';
import '../../../../shared/domain/usecases/save_user.dart';
import '../../../../shared/presentation/bloc/user/user_bloc.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/get_user_uid.dart';
import '../../domain/usecases/is_user_logged_in.dart';
import '../../domain/usecases/user_login.dart';
import '../../domain/usecases/user_logout.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/settings/settings_bloc.dart';
import 'loading_page.dart';
import 'login_page.dart';
import 'menu_page.dart';
import 'registration_page.dart';
import 'splash_page.dart';

/// {@template home_page}
/// Page container for home feature.
/// {@endtemplate}
class HomePage extends StatelessWidget {
  final _authRepository = AuthRepositoryImpl();

  final _userRepository = UserRepositoryImpl();

  /// {@macro home_page}
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);

    final authBloc = AuthenticationBloc(
      isUserLoggedIn: IsUserLoggedIn(_authRepository),
      getUserUid: GetUserUid(_authRepository),
      userLogOut: UserLogOut(_authRepository),
    );

    final userBloc = UserBloc(
      settingsBloc: settingsBloc,
      authenticationBloc: authBloc,
      getUserByUid: GetUserByUid(_userRepository),
      saveUser: SaveUser(_userRepository),
    );

    authBloc.onAuth = () {
      userBloc.add(UserEvent.fetch());
    };

    return BlocProvider(
      create: (context) => authBloc..add(AuthenticationEvent.appStarted()),
      child: BlocProvider(
        create: (context) => userBloc..add(UserEvent.fetch()),
        child: Scaffold(
          backgroundColor: c.background,
          body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              return state.when(
                uninitialized: () => SplashPage(),
                authenticated: (uid) => MenuPage(),
                unauthenticated: () => BlocProvider(
                  create: (context) => LoginBloc(
                    authenticationBloc:
                        BlocProvider.of<AuthenticationBloc>(context),
                    userLogIn: UserLogIn(_authRepository),
                    isUserRegistered: IsUserRegistered(_userRepository),
                    registerUser: RegisterUser(_userRepository),
                  ),
                  child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => LoginPage(),
                        failure: (error) => LoginPage(error: error),
                        loading: () => LoadingPage(),
                        registration: (uid) => RegistrationPage(uid: uid),
                      );
                    },
                  ),
                ),
                loading: () => LoadingPage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
