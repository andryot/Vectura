part of 'offer_ride_bloc.dart';

@immutable
abstract class OfferRideEvent {}

class CreateOffer extends OfferRideEvent {}

class RetryCreateOffer extends OfferRideEvent {}

class ResetOffer extends OfferRideEvent {}

class ResetValidation extends OfferRideEvent {}

class FromChanged extends OfferRideEvent {
  final String value;
  FromChanged(this.value);
}

class ToChanged extends OfferRideEvent {
  final String value;
  ToChanged(this.value);
}

class DateChanged extends OfferRideEvent {
  final DateTime value;
  DateChanged(this.value);
}

class AvailableSeatsChanged extends OfferRideEvent {
  final String value;
  AvailableSeatsChanged(this.value);
}

class PriceChanged extends OfferRideEvent {
  final String value;
  PriceChanged(this.value);
}

class AdditionalInfoChanged extends OfferRideEvent {
  final String value;
  AdditionalInfoChanged(this.value);
}
