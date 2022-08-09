import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../models/user/user.dart';
import '../../services/auth_service.dart';
import '../../services/keychain_service.dart';
import '../../services/local_storage_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';
import '../../util/failures/validation_failure.dart';
import '../../util/validator.dart';
import '../global/global_bloc.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final GlobalBloc _globalBloc;
  final AuthService _authService;
  final KeychainService _keychainService;
  final LocalStorageService _localStorageService;
  SignInBloc({
    required GlobalBloc globalBloc,
    required KeychainService keychainService,
    required AuthService authService,
    required LocalStorageService localStorageService,
  })  : _globalBloc = globalBloc,
        _keychainService = keychainService,
        _authService = authService,
        _localStorageService = localStorageService,
        super(const SignInState.initial()) {
    on<SubmitSignIn>(onSubmitSignIn);
    on<EmailChanged>(onEmailChanged);
    on<PasswordChanged>(onPasswordChanged);
  }

  void emailChanged(String value) => add(EmailChanged(value));
  void passwordChanged(String value) => add(PasswordChanged(value));
  void signIn() => add(SubmitSignIn());

  FutureOr<void> onSubmitSignIn(
    SubmitSignIn event,
    Emitter<SignInState> emit,
  ) async {
    if (!VecValidator.isValidEmail(state.email)) {
      emit(state.copyWith(failure: const EmailValidationFailure()));
      return;
    }
    if (!VecValidator.isValidPassword(state.password)) {
      emit(state.copyWith(failure: const PasswordValidationFailure()));
      return;
    }

    emit(state.copyWith(isLoading: true));

    final Either<BackendFailure, VecturaUser> userOrFailure =
        await _authService.login(state.email, state.password);

    if (userOrFailure.isError()) {
      emit(state.copyWith(
        isLoading: false,
        signInSuccessful: false,
        failure: userOrFailure.error,
      ));
      return;
    }

    _globalBloc.updateJwtToken(userOrFailure.value.accessToken!);
    _globalBloc.updateUser(userOrFailure.value);

    final Uint8List? profileImage =
        await _localStorageService.readProfileImage(userOrFailure.value.id);
    _globalBloc.saveProfileImage(profileImage);

    await _keychainService.saveRefreshToken(userOrFailure.value.refreshToken!);
    emit(state.copyWith(isLoading: false, signInSuccessful: true));
  }

  FutureOr<void> onEmailChanged(
    EmailChanged event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(email: event.value));
  }

  FutureOr<void> onPasswordChanged(
    PasswordChanged event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(password: event.value));
  }
}
