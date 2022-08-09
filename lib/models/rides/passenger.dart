import '../user/user.dart';
import 'vehicle.dart';

/// Model representing base user info.
class VecturaPassenger extends VecturaUser {
  /// Constructs new `VecturaPassenger` object.
  ///
  /// VecturaDriver and VecturaPassengers are no longer needed, but for now
  /// they are kept, because I don't want to change the code that uses them.
  const VecturaPassenger({
    required String id,
    required String email,
    required String name,
    required String phone,
    DateTime? createdAt,
  }) : super(
          id: id,
          email: email,
          name: name,
          phone: phone,
          createdAt: createdAt,
        );

  /// Constructs new `VecturaPassenger` object from [json].
  VecturaPassenger.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  /// Converts this object into json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      VecturaUserJsonKey.id: id,
      VecturaUserJsonKey.email: email,
      VecturaUserJsonKey.name: name,
      VecturaUserJsonKey.phone: phone,
      VecturaUserJsonKey.createdAt: createdAt,
    };
  }

  /// Returns new instance of `VecturaPassenger` with modified fields.
  @override
  VecturaPassenger copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? accessToken,
    String? refreshToken,
    VecturaVehicle? vehicle,
    bool? override,
    DateTime? createdAt,
  }) {
    return VecturaPassenger(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object? other) {
    return other is VecturaPassenger && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
