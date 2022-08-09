part of 'tab_bar_bloc.dart';

@immutable
abstract class _TabBarEvent {}

class _TabBarUpdateEvent extends _TabBarEvent {
  final int index;
  _TabBarUpdateEvent(this.index);
}

class _ResumedEvent extends _TabBarEvent {}
