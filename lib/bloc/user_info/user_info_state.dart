part of 'user_info_bloc.dart';

@immutable
class UserInfoState {
  final bool isLoading;
  final Failure? failure;
  final bool? successful;

  const UserInfoState({
    required this.isLoading,
    this.failure,
    this.successful,
  });

  const UserInfoState.initial()
      : isLoading = false,
        failure = null,
        successful = null;

  UserInfoState copyWith({
    bool? isLoading,
    Failure? failure,
    bool? successful,
  }) {
    return UserInfoState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
      successful: successful,
    );
  }
}
