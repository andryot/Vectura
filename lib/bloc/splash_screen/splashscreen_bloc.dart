import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../models/jwt_pair.dart';
import '../../models/user/user.dart';
import '../../router/routes.dart';
import '../../services/auth_service.dart';
import '../../services/connectivity_service.dart';
import '../../services/keychain_service.dart';
import '../../services/local_storage_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../global/global_bloc.dart';

part 'splashscreen_event.dart';
part 'splashscreen_state.dart';

class SplashScreenBloc extends Bloc<_SplashScreenEvent, SplashScreenState> {
  final GlobalBloc _globalBloc;
  final KeychainService _keychainService;
  final AuthService _authService;
  final ConnectivityService _connectivityService;
  final LocalStorageService _localStorageService;
  SplashScreenBloc({
    required GlobalBloc globalBloc,
    required KeychainService keychainService,
    required AuthService authService,
    required ConnectivityService connectivityService,
    required LocalStorageService localStorageService,
  })  : _globalBloc = globalBloc,
        _keychainService = keychainService,
        _authService = authService,
        _connectivityService = connectivityService,
        _localStorageService = localStorageService,
        super(const SplashScreenState.initial()) {
    on<_Initialize>(_onInitialize);

    add(_Initialize());
  }

  @override
  Future<void> close() async {
    return super.close();
  }

  // Public API

  void retry() => add(_Initialize());

  // Handlers

  FutureOr<void> _onInitialize(
    _Initialize event,
    Emitter<SplashScreenState> emit,
  ) async {
    final bool connected = await _connectivityService.isConnected();

    // if not connected show dialog with retry button
    if (!connected) {
      emit(state.copyWith(connection: false));
      return;
    }

    final List results = await Future.wait(<Future>[
      _initialize(),
      // This is taking too long
      //Future.delayed(const Duration(seconds: 2)),
    ]);

    if (results.first == null) {
      emit(state.copyWith(
        pushRoute: VecRoute.signIn,
        initialized: true,
      ));
      return;
    }

    emit(state.copyWith(
      initialized: true,
      pushRoute: results.first,
    ));
  }

  // Helpers

  Future<String?> _initialize() async {
    String? refreshToken = await _keychainService.readRefreshToken();

    if (refreshToken == null) {
      return VecRoute.signIn;
    } else {
      final Either<BackendFailure, JwtPair> tokensOrFailure =
          await _authService.refreshToken(refreshToken);

      if (tokensOrFailure.isError()) {
        await KeychainService.instance.removeRefreshToken();
        return VecRoute.signIn;
      }

      final String newAccessToken = tokensOrFailure.value.accessToken;
      final String newRefreshToken = tokensOrFailure.value.refreshToken;

      _globalBloc.updateJwtToken(newAccessToken);

      await KeychainService.instance.saveRefreshToken(newRefreshToken);

      final Either<BackendFailure, VecturaUser> userOrFailure =
          await _authService.getUserData();

      // if fetching user data fails remove refresh token and redirect to login
      if (userOrFailure.isError()) {
        await KeychainService.instance.removeRefreshToken();
        return VecRoute.signIn;
      }

      final VecturaUser user = userOrFailure.value.copyWithTokens(
          accessToken: newAccessToken, refreshToken: newRefreshToken);
      _globalBloc.updateUser(user);

      final Uint8List? profileImage =
          await _localStorageService.readProfileImage(user.id);
      _globalBloc.saveProfileImage(profileImage);

      return VecRoute.root;
    }
  }
}
