import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import '../../services/auth_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';
import '../../util/validator.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AuthService _authService;
  late final List<TextEditingController> controllers;
  ChangePasswordBloc({required AuthService authService})
      : _authService = authService,
        super(const ChangePasswordState.initial()) {
    controllers = [
      TextEditingController(),
      TextEditingController(),
    ];

    controllers[0].addListener(() {
      if (passwordsValidAndMatch()) {
        add(const _SaveButtonStatus(isEnabled: true));
      } else {
        add(const _SaveButtonStatus(isEnabled: false));
      }
    });

    controllers[1].addListener(() {
      if (passwordsValidAndMatch()) {
        add(const _SaveButtonStatus(isEnabled: true));
      } else {
        add(const _SaveButtonStatus(isEnabled: false));
      }
    });

    on<_Save>(_onSave);
    on<_SaveButtonStatus>(_onSaveButtonStatus);
    on<_ResetSuccess>(_onResetSuccess);
    on<_ResetFailure>(_onResetFailure);
  }

  @override
  Future<void> close() {
    // dispose functions are void
    controllers[0].dispose();
    controllers[1].dispose();
    return super.close();
  }

  // PUBLIC API
  void resetFailure() => add(_ResetFailure());
  void save() => add(_Save());
  void resetSuccess() => add(_ResetSuccess());

  // HANDLERS
  FutureOr<void> _onSave(
    _Save event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(isButtonEnabled: false, isLoading: true));

    final Either<BackendFailure, void> voidOrFailure =
        await _authService.changePassword(controllers[0].text);

    if (voidOrFailure.isError()) {
      emit(
        state.copyWith(
          failure: voidOrFailure.error,
          isButtonEnabled: true,
          isLoading: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: false, isSuccess: true));
  }

  FutureOr<void> _onSaveButtonStatus(
    _SaveButtonStatus event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(isButtonEnabled: event.isEnabled));
  }

  FutureOr<void> _onResetSuccess(
    _ResetSuccess event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(isSuccess: false));
    controllers[0].clear();
    controllers[1].clear();
  }

  FutureOr<void> _onResetFailure(
    _ResetFailure event,
    Emitter<ChangePasswordState> emit,
  ) {
    emit(state.copyWith(failure: null));
  }

  bool passwordsValidAndMatch() {
    return VecValidator.isValidPassword(controllers[0].text) &&
        VecValidator.isValidPassword(controllers[1].text) &&
        controllers[0].text == controllers[1].text;
  }
}
