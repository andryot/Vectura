import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../models/user/user.dart';
import '../../services/auth_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';
import '../../util/failures/validation_failure.dart';
import '../../util/validator.dart';
import '../global/global_bloc.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final GlobalBloc _globalBloc;
  final AuthService _authService;

  late final List<TextEditingController> controllers;
  UserInfoBloc({
    required GlobalBloc globalBloc,
    required AuthService authService,
  })  : _globalBloc = globalBloc,
        _authService = authService,
        super(const UserInfoState.initial()) {
    controllers = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];

    on<_Initialize>(_initialize);
    on<_UpdateUserInfo>(_updateUserInfo);
    on<_UpdateProfileImage>(_updateProfileImage);
    on<_UpdateSuccessful>(_onUpdateSuccessful);

    add(_Initialize());
  }

  void resetFailure() {}

  void buttonClicked() => add(_UpdateUserInfo());

  void imageChanged() => add(_UpdateProfileImage());

  void resetSuccess() => add(_UpdateSuccessful());

  FutureOr<void> _initialize(
      _Initialize event, Emitter<UserInfoState> emit) async {
    final VecturaUser? user = _globalBloc.state.user;

    if (user != null) {
      controllers[0].text = user.email;
      controllers[1].text = user.name;
      controllers[2].text = user.phone;
    }
  }

  FutureOr<void> _updateUserInfo(
      _UpdateUserInfo event, Emitter<UserInfoState> emit) async {
    if (!VecValidator.isValidEmail(controllers[0].text)) {
      emit(state.copyWith(failure: const EmailValidationFailure()));
      return;
    }
    if (!VecValidator.isValidName(controllers[1].text)) {
      emit(state.copyWith(failure: const NameValidationFailure()));
      return;
    }
    if (!VecValidator.isValidPhone(controllers[2].text)) {
      emit(state.copyWith(failure: const PhoneValidationFailure()));
      return;
    }

    final String? newEmail =
        controllers[0].text != _globalBloc.state.user!.email
            ? controllers[0].text
            : null;
    final String? newName = controllers[1].text != _globalBloc.state.user!.name
        ? controllers[1].text
        : null;
    final String? newPhone =
        controllers[2].text != _globalBloc.state.user!.phone
            ? controllers[2].text
            : null;

    if (newEmail == null && newName == null && newPhone == null) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    final Map<String, String?> userInfo = <String, String?>{
      VecturaUserJsonKey.email: newEmail,
      VecturaUserJsonKey.name: newName,
      VecturaUserJsonKey.phone: newPhone,
    };

    final Either<BackendFailure, void> voidOrFailure =
        await _authService.updateUserInfo(userInfo);

    if (voidOrFailure.isError()) {
      emit(state.copyWith(
        failure: voidOrFailure.error,
        isLoading: false,
      ));
      return;
    }

    _globalBloc.updateUser(
      _globalBloc.state.user!.copyWith(
        email: newEmail,
        name: newName,
        phone: newPhone,
      ),
    );

    emit(state.copyWith(isLoading: false, successful: true));
  }

  FutureOr<void> _updateProfileImage(
    _UpdateProfileImage event,
    Emitter<UserInfoState> emit,
  ) {
    emit(state.copyWith());
  }

  FutureOr<void> _onUpdateSuccessful(
      _UpdateSuccessful event, Emitter<UserInfoState> emit) {
    emit(state.copyWith(successful: null));
  }
}
