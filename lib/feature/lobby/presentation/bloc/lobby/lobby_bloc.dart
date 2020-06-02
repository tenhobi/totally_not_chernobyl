import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/usecases/can_connect_to_lobby.dart';

part 'lobby_bloc.freezed.dart';
part 'lobby_event.dart';
part 'lobby_state.dart';

/// {@template lobby_bloc}
/// Controlls lobby page.
/// {@endtemplate}
class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  /// Usecase.
  final CanConnectToLobby canConnectToLobby;

  /// {@macro lobby_bloc}
  LobbyBloc({
    @required this.canConnectToLobby,
  });

  @override
  LobbyState get initialState => LobbyState.initial();

  @override
  Stream<LobbyState> mapEventToState(LobbyEvent event) async* {
    yield* event.when(
      create: () async* {
        yield LobbyState.created();
      },
      join: () async* {
        yield LobbyState.joining();
      },
      connect: (roomUid) async* {
        final success = await canConnectToLobby(CanConnectToLobbyParams(
          roomUid: roomUid,
        ));

        yield* success.fold((l) async* {
          yield LobbyState.joining(failed: true);
        }, (r) async* {
          yield LobbyState.connected(roomUid: roomUid);
        });
      },
    );
  }
}
