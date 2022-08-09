part of 'change_password_bloc.dart';

@immutable
class ChangePasswordState {
  final bool? isLoading;
  final bool isButtonEnabled;
  final Failure? failure;
  final bool? isSuccess;

  const ChangePasswordState({
    this.isLoading,
    this.failure,
    required this.isButtonEnabled,
    this.isSuccess,
  });

  const ChangePasswordState.initial()
      : isLoading = false,
        failure = null,
        isButtonEnabled = false,
        isSuccess = null;

  ChangePasswordState copyWith({
    bool? isLoading,
    Failure? failure,
    bool? isButtonEnabled,
    bool? isSuccess,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
