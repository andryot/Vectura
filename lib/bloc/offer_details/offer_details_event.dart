part of 'offer_details_bloc.dart';

@immutable
abstract class OfferDetailsEvent {}

class _Initialize extends OfferDetailsEvent {}

class _TileClicked extends OfferDetailsEvent {
  final int index;
  _TileClicked({required this.index});
}

class _ButtonClicked extends OfferDetailsEvent {}
