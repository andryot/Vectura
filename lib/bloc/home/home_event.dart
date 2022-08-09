part of 'home_bloc.dart';

@immutable
abstract class _HomeEvent {}

class _Initialize extends _HomeEvent {}

class _Reset extends _HomeEvent {}

class _ReloadOffers extends _HomeEvent {}

class _ReloadRides extends _HomeEvent {}
