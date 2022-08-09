part of 'history_bloc.dart';

@immutable
abstract class _HistoryEvent {
  const _HistoryEvent();
}

class _Initialize extends _HistoryEvent {
  final int pageSize;
  const _Initialize({required this.pageSize});
}

class _CalculateWidth extends _HistoryEvent {}

class _SelectSegment extends _HistoryEvent {
  final int selected;
  const _SelectSegment({required this.selected});
}

class _FetchPageData extends _HistoryEvent {
  final int pageKey;
  final int selectedPage;
  const _FetchPageData({required this.pageKey, required this.selectedPage});
}

class _RefreshSegment extends _HistoryEvent {
  final int selected;
  const _RefreshSegment({required this.selected});
}

class _Retry extends _HistoryEvent {}
