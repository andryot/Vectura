part of 'offer_details_bloc.dart';

@immutable
class OfferDetailsState {
  final VecturaRide? ride;

  final Failure? failure;
  final bool? isLoading;
  final bool? isSuccessful;
  final List<bool> isExpandedList;
  final OfferDetailsViewingAs? viewingAs;
  final bool? completed;

  const OfferDetailsState({
    required this.ride,
    required this.failure,
    required this.isLoading,
    required this.isSuccessful,
    required this.isExpandedList,
    required this.viewingAs,
    required this.completed,
  });

  OfferDetailsState.initial()
      : ride = null,
        failure = null,
        isLoading = null,
        isSuccessful = null,
        isExpandedList = [false, false, false],
        viewingAs = null,
        completed = null;

  OfferDetailsState copyWith({
    VecturaRide? ride,
    bool? isLoading,
    bool? isSuccessful,
    Failure? failure,
    List<bool>? isExpandedList,
    OfferDetailsViewingAs? viewingAs,
    bool? completed,
  }) {
    return OfferDetailsState(
      ride: ride ?? this.ride,
      isLoading: isLoading ?? this.isLoading,
      isSuccessful: isSuccessful ?? this.isSuccessful,
      failure: failure,
      isExpandedList: isExpandedList ?? this.isExpandedList,
      viewingAs: viewingAs ?? this.viewingAs,
      completed: completed ?? this.completed,
    );
  }
}

enum OfferDetailsViewingAs { viewer, driver, passenger }
