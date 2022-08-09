part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {
  const ProfileEvent();
}

class _Initialize extends ProfileEvent {
  const _Initialize();
}

class _ReloadProfileImage extends ProfileEvent {
  const _ReloadProfileImage();
}

class _ReloadUser extends ProfileEvent {
  const _ReloadUser();
}

class _Reset extends ProfileEvent {}
