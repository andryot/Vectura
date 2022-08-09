part of 'register_bloc.dart';

@immutable
class RegisterState {
  final String email;
  final String password;
  final String passwordRepeat;
  final String name;
  final String phone;

  final bool isLoading;
  final bool? isRegistrationSuccessful;
  final Failure? failure;

  const RegisterState({
    required this.email,
    required this.password,
    required this.passwordRepeat,
    required this.name,
    required this.phone,
    required this.isLoading,
    required this.isRegistrationSuccessful,
    required this.failure,
  });

  const RegisterState.initial()
      : email = '',
        password = '',
        passwordRepeat = '',
        name = '',
        phone = '',
        isLoading = false,
        isRegistrationSuccessful = null,
        failure = null;

  RegisterState copyWith({
    String? email,
    String? password,
    String? passwordRepeat,
    String? name,
    String? phone,
    bool? isLoading,
    bool? isRegistrationSuccessful,
    bool? register,
    Failure? failure,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordRepeat: passwordRepeat ?? this.passwordRepeat,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isLoading: isLoading ?? this.isLoading,
      isRegistrationSuccessful: isRegistrationSuccessful,
      failure: failure,
    );
  }
}
