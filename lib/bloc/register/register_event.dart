part of 'register_bloc.dart';

@immutable
abstract class _RegisterEvent {}

class _SubmitRegister extends _RegisterEvent {
  _SubmitRegister();
}

class _EmailChanged extends _RegisterEvent {
  final String value;
  _EmailChanged(this.value);
}

class _PasswordChanged extends _RegisterEvent {
  final String value;
  _PasswordChanged(this.value);
}

class _PasswordRepeatChanged extends _RegisterEvent {
  final String value;
  _PasswordRepeatChanged(this.value);
}

class _NameChanged extends _RegisterEvent {
  final String value;
  _NameChanged(this.value);
}

class _PhoneChanged extends _RegisterEvent {
  final String value;
  _PhoneChanged(this.value);
}
