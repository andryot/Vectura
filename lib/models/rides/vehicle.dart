/// Model representing base user info.
class VecturaVehicle {
  /// The id of the vehicle.
  final String? id;

  /// The brand of the vehicle.
  final String brand;

  /// The model of the vehicle.
  final String model;

  /// The color of the vehicle.
  final String color;

  /// The licensePlate of the vehicle.
  final String licensePlate;

  /// Constructs new `VecturaVehicle` object.
  const VecturaVehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.color,
    required this.licensePlate,
  });

  /// Constructs new `VecturaVehicle` object from [json].
  VecturaVehicle.fromJson(Map<String, dynamic> json)
      : id = json[VecturaVehicleJsonKey.id],
        brand = json[VecturaVehicleJsonKey.brand],
        model = json[VecturaVehicleJsonKey.model],
        color = json[VecturaVehicleJsonKey.color],
        licensePlate = json[VecturaVehicleJsonKey.licensePlate];

  /// Converts this object into json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      if (id != null) VecturaVehicleJsonKey.id: id,
      VecturaVehicleJsonKey.brand: brand,
      VecturaVehicleJsonKey.model: model,
      VecturaVehicleJsonKey.color: color,
      VecturaVehicleJsonKey.licensePlate: licensePlate,
    };
  }

  /// Returns new instance of `VecturaVehicle` with modified fields.
  VecturaVehicle copyWith({
    String? id,
    String? brand,
    String? model,
    String? color,
    String? licensePlate,
  }) {
    return VecturaVehicle(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      color: color ?? this.color,
      licensePlate: licensePlate ?? this.licensePlate,
    );
  }

  @override
  bool operator ==(Object? other) {
    return other is VecturaVehicle && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Keys used in `VecturaVehicle` json representations.
abstract class VecturaVehicleJsonKey {
  /// Key for `VecturaVehicle.id`.
  static const String id = 'id';

  /// Key for `VecturaVehicle.brand`.
  static const String brand = 'brand';

  /// Key for `VecturaVehicle.model`.
  static const String model = 'model';

  /// Key for `VecturaVehicle.color`.
  static const String color = 'color';

  /// Key for `VecturaVehicle.license_plate`.
  static const String licensePlate = 'license_plate';
}
