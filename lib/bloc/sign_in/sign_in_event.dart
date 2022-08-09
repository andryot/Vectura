part of 'sign_in_bloc.dart';

@immutable
abstract class SignInEvent {}

class SubmitSignIn extends SignInEvent {
  SubmitSignIn();
}

class EmailChanged extends SignInEvent {
  final String value;
  EmailChanged(this.value);
}

class PasswordChanged extends SignInEvent {
  final String value;
  PasswordChanged(this.value);
}
