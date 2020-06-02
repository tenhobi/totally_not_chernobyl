import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../shared/domain/usecases/is_user_registered.dart';
import '../../../../../shared/domain/usecases/register_user.dart';
import '../../../domain/usecases/user_login.dart';
import '../authentication/authentication_bloc.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

/// {@template login_bloc}
/// This Bloc handles loging user in.
/// Also [authenticationBloc] is required, so this bloc can signalize sucessful
/// login to authentication.
/// {@endtemplate}
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  ///
  final AuthenticationBloc authenticationBloc;

  /// [UserLogIn] usecase.
  final UserLogIn userLogIn;

  /// [RegisterUser] usecase.
  final RegisterUser registerUser;

  /// [IsUserRegistered] usecase.
  final IsUserRegistered isUserRegistered;

  /// {@macro login_bloc}
  LoginBloc({
    @required this.authenticationBloc,
    @required this.userLogIn,
    @required this.registerUser,
    @required this.isUserRegistered,
  });

  @override
  LoginState get initialState => LoginState.initial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    yield* event.when(
      login: () async* {
        yield LoginState.loading();

        final login = await userLogIn(NoParams());
        yield* login.fold((l) async* {
          yield LoginState.failure(error: tr('bad_login'));
        }, (uid) async* {
          final isRegistered =
              await isUserRegistered(IsUserRegisteredParams(uid: uid));

          yield* isRegistered.fold(
            (l) => null,
            (r) async* {
              if (r) {
                authenticationBloc.add(AuthenticationEvent.loggedIn(uid: uid));
                yield LoginState.initial();
              } else {
                yield LoginState.registration(uid: uid);
              }
            },
          );
        });
      },
      register: (uid, username, language) async* {
        final registrationCompleted = await registerUser(RegisterUserParams(
          uid: uid,
          username: username,
          language: language,
        ));

        yield* registrationCompleted.fold((l) async* {
          print('error in registration');
        }, (r) async* {
          authenticationBloc.add(AuthenticationEvent.loggedIn(uid: uid));
          yield LoginState.initial();
        });
      },
    );
  }
}
