import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/rides/ride.dart';
import '../../services/backend_service.dart';
import '../../style/colors.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';
import '../../widgets/vec_animated_text.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<_HistoryEvent, HistoryState> {
  late final List<PagingController<int, VecturaRide>> pagingControllers;
  late final List<double?> _scrollOffsets;

  final ScrollController scrollController = ScrollController();
  final BackendService _backendService;
  final int pageSize;

  HistoryBloc({
    required BackendService backendService,
    required this.pageSize,
  })  : _backendService = backendService,
        super(HistoryState.initial(pageSize)) {
    on<_CalculateWidth>(onCalculateWidth);
    on<_SelectSegment>(onSelectSegment);
    on<_FetchPageData>(_onFetchPageData);
    on<_RefreshSegment>(_onRefreshSegment);
    on<_Retry>(_onRetry);

    pagingControllers = [
      PagingController(firstPageKey: 0),
      PagingController(firstPageKey: 0),
      PagingController(firstPageKey: 0),
    ];

    _scrollOffsets = [null, null, null];

    scrollController.addListener(
        () => _scrollOffsets[state.selected] = scrollController.offset);

    pagingControllers[0].addPageRequestListener(
        (pageKey) => add(_FetchPageData(pageKey: pageKey, selectedPage: 0)));

    pagingControllers[1].addPageRequestListener(
        (pageKey) => add(_FetchPageData(pageKey: pageKey, selectedPage: 1)));

    pagingControllers[2].addPageRequestListener(
        (pageKey) => add(_FetchPageData(pageKey: pageKey, selectedPage: 2)));
  }

  @override
  Future<void> close() {
    for (PagingController controller in pagingControllers) {
      controller.dispose();
    }
    scrollController.dispose();
    return super.close();
  }

  // public API

  void calculateWidths() => add(_CalculateWidth());

  void selectSegment(int page) => add(_SelectSegment(selected: page));

  void retry() => add(_Retry());

  Future<void> refresh(int selected) async =>
      add(_RefreshSegment(selected: selected));

  // Handlers

  FutureOr<void> onSelectSegment(
    _SelectSegment event,
    Emitter<HistoryState> emit,
  ) async {
    // set font weight of previously selected to w400
    state.keys[state.selected].currentState!.updateColorWithAnimation(
        VecColor.primary, VecColor.strong, FontWeight.w400);

    // set font weight of selected to w500
    if (state.keys[event.selected].currentState != null) {
      state.keys[event.selected].currentState!.updateColorWithAnimation(
          VecColor.strong, VecColor.primary, FontWeight.w500);
    }

    // fetch page data if item list is null
    if (pagingControllers[event.selected].itemList == null) {
      add(_FetchPageData(pageKey: 0, selectedPage: event.selected));
    }

    emit(state.copyWith(selected: event.selected));
    scrollController.jumpTo(_scrollOffsets[event.selected] ?? 0);

    add(_CalculateWidth());
  }

  FutureOr<void> _onFetchPageData(
    _FetchPageData event,
    Emitter<HistoryState> emit,
  ) async {
    final List<VecturaRide>? rides = await _fetchData(event.selectedPage);

    if (rides == null) {
      emit(state.copyWith(failure: const UnknownBackendFailure()));
      return;
    }

    final int selected = event.selectedPage;

    try {
      final bool isLastPage = rides.length < state.pageSize;
      if (isLastPage) {
        pagingControllers[selected].appendLastPage(rides);
      } else {
        final int nextPageKey = event.pageKey + rides.length;
        pagingControllers[selected].appendPage(rides, nextPageKey);
        state.pages[selected]++;
      }
    } catch (error) {
      debugPrint(error.toString());
      pagingControllers[selected].error = error;
    }
  }

  FutureOr<void> _onRefreshSegment(
    _RefreshSegment event,
    Emitter<HistoryState> emit,
  ) async {
    // we could just do pagingControllers[event.selected].itemList = [];
    // and then reload, but that triggers the noItemsFoundIndicatorBuilder
    // for the duration of reloading that replaces previously loaded items in
    // the UI with loading indicator
    // pagingControllers[event.selected].refresh() is also not ok
    state.pages[event.selected] = 0;
    final List<VecturaRide>? rides = await _fetchData(event.selected);

    if (rides == null) {
      emit(state.copyWith(failure: const UnknownBackendFailure()));
      return;
    }

    state.pages[event.selected] = rides.length < state.pageSize ? 0 : 1;

    pagingControllers[event.selected].value = PagingState<int, VecturaRide>(
      itemList: rides,
      error: null,
      nextPageKey: rides.length < state.pageSize ? null : rides.length,
    );

    emit(state.copyWith(pages: state.pages));
  }

  Future<List<VecturaRide>?> _fetchData(int selectedPage) async {
    // filter is reversed on BE in comparison with UI -> 2 - state.selected
    final Either<BackendFailure, List<VecturaRide>> offersOrFailure =
        await _backendService.rideHistory(
            2 - selectedPage, state.pages[selectedPage], state.pageSize);

    if (offersOrFailure.isError()) return null;

    return offersOrFailure.value;
  }

  FutureOr<void> _onRetry(
    _Retry event,
    Emitter<HistoryState> emit,
  ) {
    // TODO save failed request and retry it
    //add(_FetchPageData(pageKey: state.pages[state.selected]));
  }

  // UI functions
  FutureOr<void> onCalculateWidth(
    _CalculateWidth event,
    Emitter<HistoryState> emit,
  ) async {
    final List<Size> sizeList = getSize(state.keys);
    emit(state.copyWith(sizeList: sizeList));
  }

  List<Size> getSize(List<GlobalKey> keys) {
    final List<Size> widthList = [];
    for (GlobalKey key in keys) {
      widthList.insert(
          widthList.length,
          (key.currentContext != null && key.currentContext!.size != null)
              ? key.currentContext!.size!
              : const Size(0, 0));
    }
    return widthList;
  }
}
