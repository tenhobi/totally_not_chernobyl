import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_user_uid.dart';
import '../../../domain/usecases/is_user_logged_in.dart';
import '../../../domain/usecases/user_logout.dart';

part 'authentication_bloc.freezed.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

/// {@template authentication_bloc}
/// Bloc for authentication.
///
/// In this Bloc the state of authentication is kept
/// and all the nessesary parts are run.
/// {@endtemplate}
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  /// Callback function
  Function() onAuth;

  /// Auth repository that provides logic to authenticate.
  final IsUserLoggedIn isUserLoggedIn;

  /// [GetUserUid] usecase.
  final GetUserUid getUserUid;

  /// [UserLogOut] usecase.
  final UserLogOut userLogOut;

  /// {@macro authentication_bloc}
  AuthenticationBloc({
    @required this.isUserLoggedIn,
    @required this.getUserUid,
    @required this.userLogOut,
  });

  @override
  AuthenticationState get initialState => AuthenticationState.uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    yield* event.when(
      appStarted: () async* {
        final isLoggedIn = await isUserLoggedIn(NoParams());

        yield* isLoggedIn.fold(
          (l) async* {
            yield AuthenticationState.unauthenticated();
          },
          (r) async* {
            if (r) {
              final userUid = await getUserUid(NoParams());
              yield* userUid.fold((l) async* {
                yield AuthenticationState.unauthenticated();
              }, (uid) async* {
                onAuth();
                yield AuthenticationState.authenticated(uid: uid);
              });
            } else {
              yield AuthenticationState.unauthenticated();
            }
          },
        );
      },
      loggedIn: (uid) async* {
        yield AuthenticationState.loading();
        onAuth();
        yield AuthenticationState.authenticated(uid: uid);
      },
      loggedOut: () async* {
        yield AuthenticationState.loading();
        await userLogOut(NoParams());
        yield AuthenticationState.unauthenticated();
      },
    );
  }
}
