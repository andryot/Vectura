import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/user/user.dart';
import '../../services/auth_service.dart';
import '../../services/keychain_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';
import '../../util/failures/validation_failure.dart';
import '../../util/validator.dart';
import '../global/global_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<_RegisterEvent, RegisterState> {
  final GlobalBloc _globalBloc;
  final AuthService _authService;
  final KeychainService _keychainService;

  RegisterBloc(
      {required GlobalBloc globalBloc,
      required AuthService authService,
      required KeychainService keychainService})
      : _globalBloc = globalBloc,
        _authService = authService,
        _keychainService = keychainService,
        super(const RegisterState.initial()) {
    on<_SubmitRegister>(_onSubmitRegister);
    on<_EmailChanged>(_onEmailChanged);
    on<_PasswordChanged>(_onPasswordChanged);
    on<_PasswordRepeatChanged>(_onPasswordRepeatChanged);
    on<_NameChanged>(_onNameChanged);
    on<_PhoneChanged>(_onPhoneChanged);
  }

  // Public API

  void register() => add(_SubmitRegister());
  void emailChanged(String value) => add(_EmailChanged(value));
  void passwordChanged(String value) => add(_PasswordChanged(value));
  void passwordRepeatChanged(String value) =>
      add(_PasswordRepeatChanged(value));
  void nameChanged(String value) => add(_NameChanged(value));
  void phoneChanged(String value) => add(_PhoneChanged(value));

  // Handlers

  FutureOr<void> _onSubmitRegister(
    _SubmitRegister event,
    Emitter<RegisterState> emit,
  ) async {
    if (!VecValidator.isValidEmail(state.email)) {
      emit(state.copyWith(failure: const EmailValidationFailure()));
      return;
    }
    if (!VecValidator.isValidPassword(state.password)) {
      emit(state.copyWith(failure: const PasswordValidationFailure()));
      return;
    }
    if (state.passwordRepeat != state.password) {
      emit(state.copyWith(failure: const PasswordRepeatValidationFailure()));
      return;
    }
    if (!VecValidator.isValidName(state.name)) {
      emit(state.copyWith(failure: const NameValidationFailure()));
      return;
    }
    if (!VecValidator.isValidPhone(state.phone)) {
      emit(state.copyWith(failure: const PhoneValidationFailure()));
      return;
    }

    emit(state.copyWith(isLoading: true));

    final Either<BackendFailure, VecturaUser> userOrFailure = await _authService
        .register(state.email, state.password, state.name, state.phone);

    if (userOrFailure.isError()) {
      emit(state.copyWith(
        isLoading: false,
        isRegistrationSuccessful: false,
        failure: userOrFailure.error,
      ));
      return;
    }

    _globalBloc.updateJwtToken(userOrFailure.value.accessToken!);
    await _keychainService.saveRefreshToken(userOrFailure.value.refreshToken!);
    // debugPrint(userOrFailure.value.refreshToken);
    _globalBloc.updateUser(userOrFailure.value);
    emit(state.copyWith(isLoading: false, isRegistrationSuccessful: true));
  }

  FutureOr<void> _onEmailChanged(
    _EmailChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(email: event.value));
  }

  FutureOr<void> _onPasswordChanged(
    _PasswordChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(password: event.value));
  }

  FutureOr<void> _onPasswordRepeatChanged(
    _PasswordRepeatChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(passwordRepeat: event.value));
  }

  FutureOr<void> _onNameChanged(
    _NameChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(name: event.value));
  }

  FutureOr<void> _onPhoneChanged(
    _PhoneChanged event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(phone: event.value));
  }
}
