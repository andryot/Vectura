import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/rides/ride.dart';
import '../../services/backend_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../global/global_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<_HomeEvent, HomeState> {
  late final StreamSubscription _offersSubscription;
  late final StreamSubscription _ridesSubscription;
  final GlobalBloc _globalBloc;
  HomeBloc({required GlobalBloc globalBloc})
      : _globalBloc = globalBloc,
        super(const HomeState.initial()) {
    _offersSubscription =
        _globalBloc.globalOffersStream.listen((offers) => add(_ReloadOffers()));

    _ridesSubscription =
        _globalBloc.globalRidesStream.listen((rides) => add(_ReloadRides()));

    on<_Initialize>(_onInitialize);
    on<_Reset>(_onReset);
    on<_ReloadOffers>(_onReloadOffers);
    on<_ReloadRides>(_onReloadRides);

    add(_Initialize());
  }

  @override
  Future<void> close() async {
    await _ridesSubscription.cancel();
    await _offersSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onInitialize(
    _Initialize event,
    Emitter<HomeState> emit,
  ) async {
    final Either<BackendFailure, List<VecturaRide>> ridesOrFailure =
        await BackendService.instance.getRides();

    if (ridesOrFailure.isError()) {
      emit(state.copyWith(isSuccessful: false));
      return;
    }

    List<VecturaRide> ridesList = [];
    List<VecturaRide> offersList = [];

    for (VecturaRide ride in ridesOrFailure.value) {
      if (_globalBloc.state.user == ride.driver) {
        offersList.add(ride);
      } else {
        ridesList.add(ride);
      }
    }

    _globalBloc.updateUserRidesAndOffers(ridesList, offersList);

    emit(state.copyWith(
        initialized: true, rides: ridesList, offers: offersList));
  }

  FutureOr<void> _onReset(
    _Reset event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState.initial());
    add(_Initialize());
  }

  FutureOr<void> _onReloadOffers(
    _ReloadOffers event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(offers: _globalBloc.state.myOffers));
  }

  FutureOr<void> _onReloadRides(
    _ReloadRides event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(rides: _globalBloc.state.myRides));
  }

  // Public API

  Future<void> refresh() async => add(_Initialize());

  void reset() async => add(_Reset());
}
