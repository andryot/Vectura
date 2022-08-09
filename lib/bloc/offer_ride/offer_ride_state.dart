part of 'offer_ride_bloc.dart';

@immutable
class OfferRideState {
  final String from;
  final String to;
  final DateTime? dateTime;
  final int availableSeats;
  final String price;
  final String? note;
  final bool isLoading;
  final bool? createSuccessful;
  final Failure? failure;

  final String? id;

  const OfferRideState(
      {required this.from,
      required this.to,
      required this.dateTime,
      required this.availableSeats,
      required this.price,
      required this.note,
      required this.isLoading,
      required this.createSuccessful,
      required this.failure,
      required this.id});

  const OfferRideState.initial()
      : from = "",
        to = "",
        dateTime = null,
        availableSeats = 0,
        price = "",
        note = null,
        isLoading = false,
        createSuccessful = null,
        failure = null,
        id = null;

  OfferRideState copyWith({
    String? from,
    String? to,
    DateTime? dateTime,
    int? availableSeats,
    String? price,
    String? note,
    bool? isLoading,
    bool? createSuccessful,
    Failure? failure,
    String? id,
  }) {
    return OfferRideState(
      from: from ?? this.from,
      to: to ?? this.to,
      dateTime: dateTime ?? this.dateTime,
      availableSeats: availableSeats ?? this.availableSeats,
      price: price ?? this.price,
      note: note ?? this.note,
      isLoading: isLoading ?? this.isLoading,
      createSuccessful: createSuccessful ?? this.createSuccessful,
      failure: failure,
      id: id ?? this.id,
    );
  }
}
