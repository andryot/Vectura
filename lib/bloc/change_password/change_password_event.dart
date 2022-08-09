part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {
  const ChangePasswordEvent();
}

class _Save extends ChangePasswordEvent {}

class _SaveButtonStatus extends ChangePasswordEvent {
  final bool isEnabled;
  const _SaveButtonStatus({required this.isEnabled});
}

class _ResetSuccess extends ChangePasswordEvent {}

class _ResetFailure extends ChangePasswordEvent {}
