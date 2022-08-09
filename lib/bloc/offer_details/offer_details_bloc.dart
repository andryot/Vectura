import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../models/rides/ride.dart';
import '../../services/backend_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';
import '../global/global_bloc.dart';

part 'offer_details_event.dart';
part 'offer_details_state.dart';

class OfferDetailsBloc extends Bloc<OfferDetailsEvent, OfferDetailsState> {
  final String rideId;
  final BackendService _backendService;
  final GlobalBloc _globalBloc;
  OfferDetailsBloc(
      {required this.rideId,
      required BackendService backendService,
      required GlobalBloc globalBloc})
      : _backendService = backendService,
        _globalBloc = globalBloc,
        super(OfferDetailsState.initial()) {
    on<_Initialize>(_onInitialize);
    on<_TileClicked>(_onTileClicked);
    on<_ButtonClicked>(_onButtonClicked);

    add(_Initialize());
  }

  // Public API
  void clicked(int index) => add(_TileClicked(index: index));

  void buttonClicked() => add(_ButtonClicked());

  // Handlers

  FutureOr<void> _onInitialize(
    _Initialize event,
    Emitter<OfferDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final Either<BackendFailure, VecturaRide> rideOrFailure =
        await _backendService.getRideDetails(rideId);

    if (rideOrFailure.isError()) {
      emit(state.copyWith(
          isSuccessful: false, isLoading: false, failure: rideOrFailure.error));
      return;
    }

    OfferDetailsViewingAs viewingAs = OfferDetailsViewingAs.viewer;

    if (rideOrFailure.value.driver == GlobalBloc.instance.state.user) {
      viewingAs = OfferDetailsViewingAs.driver;
    }

    for (VecturaRide ride in GlobalBloc.instance.state.myRides!) {
      if (ride == rideOrFailure.value) {
        viewingAs = OfferDetailsViewingAs.passenger;
        break;
      }
    }

    emit(state.copyWith(
      ride: rideOrFailure.value,
      isSuccessful: true,
      isLoading: false,
      viewingAs: viewingAs,
    ));
  }

  FutureOr<void> _onTileClicked(
    _TileClicked event,
    Emitter<OfferDetailsState> emit,
  ) async {
    List<bool> newExpandedList = state.isExpandedList;

    if (state.isExpandedList[event.index] == true) {
      newExpandedList[event.index] = false;
    } else {
      for (int i = 0; i < 3; i++) {
        newExpandedList[i] = false;
      }
      newExpandedList[event.index] = true;
    }

    emit(state.copyWith(isExpandedList: newExpandedList));
    return;
  }

  FutureOr<void> _onButtonClicked(
    _ButtonClicked event,
    Emitter<OfferDetailsState> emit,
  ) async {
    final Either<BackendFailure, void> successOrFailure;

    // i guess this one doesn't work without being late
    late final OfferDetailsViewingAs? viewingAs;

    switch (state.viewingAs) {
      case OfferDetailsViewingAs.passenger:
        successOrFailure = await _backendService.cancelJoinRide(rideId);
        viewingAs = OfferDetailsViewingAs.viewer;
        break;
      case OfferDetailsViewingAs.viewer:
        successOrFailure = await _backendService.joinRide(rideId);
        viewingAs = OfferDetailsViewingAs.passenger;
        break;
      case OfferDetailsViewingAs.driver:
        successOrFailure = await _backendService.deleteRide(rideId);
        break;
      default:
        emit(state.copyWith(failure: const UnknownBackendFailure()));
        return;
    }

    if (successOrFailure.isError()) {
      emit(state.copyWith(failure: successOrFailure.error));
      return;
    }

    if (state.viewingAs == OfferDetailsViewingAs.driver) {
      _globalBloc.removeOffer(rideId);
      // this pops the details screen
      emit(state.copyWith(completed: true));
      return;
    }

    final Either<BackendFailure, VecturaRide> rideOrFailure =
        await _backendService.getRideDetails(rideId);

    // not sure how to handle this error -> the previous action complets and
    // the UI needs to rebuild with new ride details
    if (rideOrFailure.isError()) {
      emit(state.copyWith(failure: rideOrFailure.error));
      return;
    }

    emit(state.copyWith(viewingAs: viewingAs, ride: rideOrFailure.value));

    if (viewingAs == OfferDetailsViewingAs.passenger) {
      _globalBloc.addRide(rideOrFailure.value);
    } else {
      _globalBloc.removeRide(rideOrFailure.value.id!);
    }

    return;
  }
}
