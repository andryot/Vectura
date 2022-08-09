part of 'history_bloc.dart';

@immutable
class HistoryState {
  final int selected;
  final List<GlobalKey<VecAnimatedTextState>> keys;
  final List<Size> sizeList;

  final List<int> pages;
  final int pageSize;

  final Failure? failure;

  const HistoryState({
    required this.selected,
    required this.keys,
    required this.sizeList,
    required this.pages,
    required this.pageSize,
    required this.failure,
  });

  HistoryState.initial(this.pageSize)
      : selected = 0,
        keys = [GlobalKey(), GlobalKey(), GlobalKey()],
        sizeList = [const Size(0, 0), const Size(0, 0), const Size(0, 0)],
        pages = [0, 0, 0],
        failure = null;

  HistoryState copyWith(
      {int? selected,
      List<GlobalKey<VecAnimatedTextState>>? keys,
      List<Size>? sizeList,
      List<VecturaRide>? pastRides,
      List<VecturaRide>? pastOffers,
      List<VecturaRide>? pastRidesAndOffers,
      bool? initialized,
      List<int>? pages,
      int? pageSize,
      Failure? failure}) {
    return HistoryState(
      selected: selected ?? this.selected,
      keys: keys ?? this.keys,
      sizeList: sizeList ?? this.sizeList,
      pages: pages ?? this.pages,
      pageSize: pageSize ?? this.pageSize,
      failure: failure,
    );
  }
}
