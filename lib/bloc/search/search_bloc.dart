import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

import '../../models/rides/ride.dart';
import '../../services/backend_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<_SearchEvent, SearchState> {
  final PagingController<int, List<VecturaRide>> pagingController =
      PagingController(firstPageKey: 0, invisibleItemsThreshold: 1);
  final BackendService _backendService;

  SearchBloc({required BackendService backendService})
      : _backendService = backendService,
        super(const SearchState.initial()) {
    on<_Initialize>(_onInitialize);
    on<_NewPageFetch>(_onNewPageFetch);
    on<_Refresh>(_onRefresh);

    pagingController
        .addPageRequestListener((pageKey) => add(const _NewPageFetch()));

    add(const _Initialize());
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }

  // Public API

  Future<void> refresh() async => add(const _Refresh());

  // Handlers

  FutureOr<void> _onInitialize(
    _Initialize event,
    Emitter<SearchState> emit,
  ) async {
    final List<VecturaRide>? offers = await _fetchData(state.page);

    if (offers == null) {
      emit(state.copyWith(failure: const UnknownBackendFailure()));
      return;
    }
    if (offers.isEmpty) {
      pagingController.nextPageKey = null;
      emit(state.copyWith(initialized: true));
      return;
    }

    final List<List<VecturaRide>> offersList = _groupOffers(offers);

    try {
      final bool isLastPage = offers.length < state.pageSize;
      if (state.page > 0 &&
          _areSameEpochDates(pagingController.itemList!.last.first.startAt,
              offersList.first.first.startAt)) {
        pagingController.itemList!.last.addAll(offersList.first);
        offersList.remove(offersList.first);
      }
      if (isLastPage) {
        pagingController.appendLastPage(offersList);
      } else {
        final int nextPageKey = state.page + offers.length;
        pagingController.appendPage(offersList, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
    emit(state.copyWith(initialized: true, page: state.page + 1));
  }

  FutureOr<void> _onNewPageFetch(
    _NewPageFetch event,
    Emitter<SearchState> emit,
  ) async {
    add(const _Initialize());
  }

  FutureOr<void> _onRefresh(
    _Refresh event,
    Emitter<SearchState> emit,
  ) async {
    final List<VecturaRide>? offers = await _fetchData(0);

    if (offers == null) {
      emit(state.copyWith(failure: const UnknownBackendFailure()));
      return;
    }

    final List<List<VecturaRide>> offersList = _groupOffers(offers);

    pagingController.value = PagingState<int, List<VecturaRide>>(
      itemList: offersList,
      error: null,
      nextPageKey: offers.length < state.pageSize ? null : offers.length,
    );

    emit(state.copyWith(page: 1, failure: null));
  }

  Future<List<VecturaRide>?> _fetchData(int page) async {
    final Either<BackendFailure, List<VecturaRide>> offersOrFailure =
        await _backendService.searchRides(page, state.pageSize);

    if (offersOrFailure.isError()) return null;

    return offersOrFailure.value;
  }

  // Group rides by same date to display them in same card
  List<List<VecturaRide>> _groupOffers(List<VecturaRide> offers) {
    if (offers.isEmpty) return [];
    final List<List<VecturaRide>> offersList = [];
    VecturaRide previous = offers.first;
    final List<VecturaRide> currentDateCard = [previous];

    for (VecturaRide offer in offers.skip(1)) {
      if (_areSameEpochDates(previous.startAt, offer.startAt)) {
        currentDateCard.add(offer);
        continue;
      }
      previous = offer;
      offersList.add(currentDateCard.toList());
      currentDateCard.clear();
      currentDateCard.add(previous);
    }
    offersList.add(currentDateCard.toList());
    return offersList;
  }

  bool _areSameEpochDates(DateTime first, DateTime second) {
    if (first.day == second.day &&
        first.month == second.month &&
        first.year == second.year) {
      return true;
    }
    return false;
  }
}
