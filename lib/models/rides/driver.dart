import '../user/user.dart';
import 'vehicle.dart';

/// Model representing base user info.
class VecturaDriver extends VecturaUser {
  /// Constructs new `VecturaDriver` object.
  ///
  /// VecturaDriver and VecturaPassengers are no longer needed, but for now
  /// they are kept, because I don't want to change the code that uses them.
  const VecturaDriver({
    required String id,
    required String email,
    required String name,
    required String phone,
    required VecturaVehicle? vehicle,
    required DateTime? createdAt,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          vehicle: vehicle,
          createdAt: createdAt,
        );

  /// Constructs new `VecturaDriver` object from [json].
  VecturaDriver.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  /// Converts this object into json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      VecturaUserJsonKey.id: id,
      VecturaUserJsonKey.email: email,
      VecturaUserJsonKey.name: name,
      VecturaUserJsonKey.phone: phone,
      VecturaUserJsonKey.vehicle: vehicle,
      VecturaUserJsonKey.createdAt: createdAt,
    };
  }

  /// Returns new instance of `VecturaDriver` with modified fields.
  @override
  VecturaUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? accessToken,
    String? refreshToken,
    VecturaVehicle? vehicle,
    DateTime? createdAt,
    bool? override,
  }) {
    return VecturaDriver(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      vehicle: vehicle ?? this.vehicle,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object? other) {
    return other is VecturaUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
