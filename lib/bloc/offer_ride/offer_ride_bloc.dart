import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../models/rides/location.dart';
import '../../models/rides/ride.dart';
import '../../services/backend_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';
import '../../util/failures/validation_failure.dart';
import '../../util/validator.dart';
import '../global/global_bloc.dart';

part 'offer_ride_event.dart';
part 'offer_ride_state.dart';

class OfferRideBloc extends Bloc<OfferRideEvent, OfferRideState> {
  final BackendService _backendService;
  OfferRideBloc({required BackendService backendService})
      : _backendService = backendService,
        super(const OfferRideState.initial()) {
    on<CreateOffer>(onCreateOffer);
    on<RetryCreateOffer>(onRetryCreateOffer);

    on<FromChanged>(onFromChanged);
    on<ToChanged>(onToChanged);
    on<DateChanged>(onDateChanged);
    on<AvailableSeatsChanged>(onAvailableSeatsChanged);
    on<PriceChanged>(onPriceChanged);
    on<AdditionalInfoChanged>(onAdditionalInfoChanged);

    on<ResetOffer>(onResetOffer);
    on<ResetValidation>(onResetValidation);
  }

  void fromChanged(String value) => add(FromChanged(value));
  void toChanged(String value) => add(ToChanged(value));
  void dateChanged(DateTime value) => add(DateChanged(value));
  void availableSeatsChanged(String value) => add(AvailableSeatsChanged(value));
  void priceChanged(String value) => add(PriceChanged(value));
  void additionalInfoChanged(String value) => add(AdditionalInfoChanged(value));

  void retry() => add(RetryCreateOffer());

  void reset() => add(ResetOffer());
  void resetValidation() => add(ResetValidation());

  FutureOr<void> onCreateOffer(
    CreateOffer event,
    Emitter<OfferRideState> emit,
  ) async {
    if (!VecValidator.isValidAddress(state.from)) {
      emit(state.copyWith(failure: const AddressValidationFailure()));
      return;
    }

    if (!VecValidator.isValidAddress(state.to)) {
      emit(state.copyWith(failure: const AddressValidationFailure()));
      return;
    }

    if (state.dateTime == null || !VecValidator.isValidDate(state.dateTime!)) {
      emit(state.copyWith(failure: const DateValidationFailure()));
      return;
    }

    if (state.availableSeats == 0 ||
        !VecValidator.isInteger(state.availableSeats.toString())) {
      emit(state.copyWith(
        failure: const IntegerParsingFailure(),
        availableSeats: 0,
      ));
      return;
    }

    if (!VecValidator.isValidPrice(state.price)) {
      emit(state.copyWith(failure: const PriceValidationFailure()));
      return;
    }

    emit(state.copyWith(isLoading: true));

    final VecturaRide ride = VecturaRide(
        // until location fields are plain text, lat and lng are set to 0
        locFrom: VecturaLocation(title: state.from, lat: 0, lng: 0),
        locTo: VecturaLocation(title: state.to, lat: 0, lng: 0),
        startAt: state.dateTime!,
        maxPassengers: state.availableSeats,
        price: state.price,
        createdAt: null,
        driver: null,
        id: null,
        passengers: [],
        note: state.note);

    final Either<BackendFailure, String> rideIdOrFailure =
        await _backendService.createRide(ride);

    if (rideIdOrFailure.isError()) {
      emit(state.copyWith(
        createSuccessful: false,
        isLoading: false,
        failure: rideIdOrFailure.error,
      ));
      return;
    }

    GlobalBloc.instance.addOffer(ride.copyWith(id: rideIdOrFailure.value));

    emit(state.copyWith(
        isLoading: false, createSuccessful: true, id: rideIdOrFailure.value));
  }

  FutureOr<void> onResetOffer(
    ResetOffer event,
    Emitter<OfferRideState> emit,
  ) async {
    emit(const OfferRideState.initial());
  }

  FutureOr<void> onResetValidation(
    ResetValidation event,
    Emitter<OfferRideState> emit,
  ) async {
    emit(state.copyWith(failure: null));
  }

  FutureOr<void> onRetryCreateOffer(
    RetryCreateOffer event,
    Emitter<OfferRideState> emit,
  ) async {
    emit(
        state.copyWith(isLoading: null, createSuccessful: null, failure: null));
    add(CreateOffer());
  }

  FutureOr<void> onFromChanged(
    FromChanged event,
    Emitter<OfferRideState> emit,
  ) async {
    emit(state.copyWith(from: event.value));
  }

  FutureOr<void> onToChanged(
    ToChanged event,
    Emitter<OfferRideState> emit,
  ) async {
    emit(state.copyWith(to: event.value));
  }

  FutureOr<void> onDateChanged(
    DateChanged event,
    Emitter<OfferRideState> emit,
  ) async {
    emit(state.copyWith(dateTime: event.value));
  }

  FutureOr<void> onAvailableSeatsChanged(
    AvailableSeatsChanged event,
    Emitter<OfferRideState> emit,
  ) async {
    if (event.value == "") return;
    if (!VecValidator.isInteger(event.value)) {
      emit(state.copyWith(failure: const IntegerParsingFailure()));
      return;
    }
    emit(state.copyWith(availableSeats: int.parse(event.value)));
  }

  FutureOr<void> onPriceChanged(
    PriceChanged event,
    Emitter<OfferRideState> emit,
  ) async {
    emit(state.copyWith(price: event.value));
  }

  FutureOr<void> onAdditionalInfoChanged(
    AdditionalInfoChanged event,
    Emitter<OfferRideState> emit,
  ) async {
    emit(state.copyWith(note: event.value));
  }
}
