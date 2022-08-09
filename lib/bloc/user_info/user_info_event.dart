part of 'user_info_bloc.dart';

@immutable
abstract class UserInfoEvent {}

class _Initialize extends UserInfoEvent {}

class _UpdateUserInfo extends UserInfoEvent {}

class _UpdateProfileImage extends UserInfoEvent {}

class _UpdateSuccessful extends UserInfoEvent {}
