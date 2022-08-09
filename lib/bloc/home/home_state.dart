part of 'home_bloc.dart';

@immutable
class HomeState {
  final bool initialized;
  final List<VecturaRide>? rides;
  final List<VecturaRide>? offers;
  final bool? isSuccessful;

  const HomeState(
      {required this.initialized,
      required this.rides,
      required this.offers,
      required this.isSuccessful});

  const HomeState.initial()
      : initialized = false,
        rides = null,
        offers = null,
        isSuccessful = null;

  HomeState copyWith(
      {bool? initialized,
      bool? isSuccessful,
      List<VecturaRide>? rides,
      List<VecturaRide>? offers}) {
    return HomeState(
        initialized: initialized ?? this.initialized,
        rides: rides ?? this.rides,
        offers: offers ?? this.offers,
        isSuccessful: isSuccessful ?? this.isSuccessful);
  }
}
