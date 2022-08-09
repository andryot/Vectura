part of 'search_bloc.dart';

@immutable
abstract class _SearchEvent {
  const _SearchEvent();
}

class _Initialize extends _SearchEvent {
  const _Initialize();
}

class _NewPageFetch extends _SearchEvent {
  const _NewPageFetch();
}

class _Refresh extends _SearchEvent {
  const _Refresh();
}
