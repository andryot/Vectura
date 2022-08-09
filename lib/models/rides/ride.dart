import 'dart:convert';

import 'driver.dart';
import 'location.dart';
import 'passenger.dart';

/// Model representing base ride info.
class VecturaRide {
  /// The id of the ride.
  final String? id;

  /// The driver of the ride.
  final VecturaDriver? driver;

  /// The loc_from location of the ride.
  final VecturaLocation locFrom;

  /// The locTo location of the ride.
  final VecturaLocation locTo;

  /// The startAt time of the ride.
  final DateTime startAt;

  /// The number of maxPassengers left for the ride.
  final int maxPassengers;

  /// The passengers of the ride.
  final List<VecturaPassenger> passengers;

  /// The price of the ride.
  final String price;

  /// The createdAt time of the ride.
  final int? createdAt;

  final String? note;

  /// Constructs new `VecturaRide` object.
  const VecturaRide(
      {required this.id,
      required this.driver,
      required this.locFrom,
      required this.locTo,
      required this.startAt,
      required this.maxPassengers,
      required this.passengers,
      required this.price,
      required this.createdAt,
      required this.note});

  /// Constructs new `VecturaRide` object locFrom [json].
  VecturaRide.fromJson(Map<String, dynamic> json)
      : id = json[VecturaRideJsonKey.id],
        driver = VecturaDriver.fromJson(json[VecturaRideJsonKey.driver]),
        locFrom = VecturaLocation.fromJson(json[VecturaRideJsonKey.locFrom]),
        locTo = VecturaLocation.fromJson(json[VecturaRideJsonKey.locTo]),
        startAt = DateTime.fromMillisecondsSinceEpoch(
            json[VecturaRideJsonKey.startAt]),
        maxPassengers = json[VecturaRideJsonKey.maxPassengers],
        passengers = (json[VecturaRideJsonKey.passengers])
            .map<VecturaPassenger>((i) => VecturaPassenger.fromJson(i))
            .toList(),
        price = json[VecturaRideJsonKey.price],
        createdAt = json[VecturaRideJsonKey.createdAt],
        note = json[VecturaRideJsonKey.note];

  /// Converts this object inlocTo json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      if (id != null) VecturaRideJsonKey.id: id,
      if (driver != null) VecturaRideJsonKey.driver: driver!.toJson(),
      VecturaRideJsonKey.locFrom: locFrom.toJson(),
      VecturaRideJsonKey.locTo: locTo.toJson(),
      VecturaRideJsonKey.startAt: startAt.toUtc().millisecondsSinceEpoch,
      VecturaRideJsonKey.maxPassengers: maxPassengers,
      VecturaRideJsonKey.passengers: jsonEncode(passengers),
      VecturaRideJsonKey.price: price,
      if (createdAt != null) VecturaRideJsonKey.createdAt: createdAt,
      if (note != null) VecturaRideJsonKey.note: note,
    };
  }

  /// Returns new instance of `VecturaRide` with modified fields.
  VecturaRide copyWith({
    String? id,
    VecturaDriver? driver,
    VecturaLocation? locFrom,
    VecturaLocation? locTo,
    DateTime? startAt,
    int? maxPassengers,
    List<VecturaPassenger>? passengers,
    String? price,
    int? createdAt,
    String? note,
  }) {
    return VecturaRide(
      id: id ?? this.id,
      driver: driver ?? this.driver,
      locFrom: locFrom ?? this.locFrom,
      locTo: locTo ?? this.locTo,
      startAt: startAt ?? this.startAt,
      maxPassengers: maxPassengers ?? this.maxPassengers,
      passengers: passengers ?? this.passengers,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object? other) {
    return other is VecturaRide && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Keys used in `VecturaRide` json representations.
abstract class VecturaRideJsonKey {
  /// Key for `VecturaRide.id`.
  static const String id = 'id';

  /// Key for `VecturaRide.driver`.
  static const String driver = 'driver';

  /// Key for `VecturaRide.locFrom`.
  static const String locFrom = 'loc_from';

  /// Key for `VecturaRide.locTo`.
  static const String locTo = 'loc_to';

  /// Key for `VecturaRide.startAt`.
  static const String startAt = 'start_at';

  /// Key for `VecturaRide.maxPassengers`.
  static const String maxPassengers = 'max_passengers';

  /// Key for `VecturaRide.passengers`.
  static const String passengers = 'passengers';

  /// Key for `VecturaRide.price`.
  static const String price = 'price';

  /// Key for `VecturaRide.createdAt`.
  static const String createdAt = 'created_at';

  /// Key for `VecturaRide.note`.
  static const String note = 'note';
}
