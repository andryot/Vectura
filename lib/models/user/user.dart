import '../rides/driver.dart';
import '../rides/vehicle.dart';

/// Model representing base user info.
class VecturaUser {
  /// The id of the user.
  final String id;

  /// The email of the user.
  final String email;

  /// The password of the user, PLAIN.
  final String? password;

  /// The name of the user.
  final String name;

  /// The phone of the user
  final String phone;

  /// Access token corresponding to user.
  final String? accessToken;

  /// Refresh token corresponding to user.
  final String? refreshToken;

  /// The vehicle of the user.
  final VecturaVehicle? vehicle;

  // The createdAt of the user.
  final DateTime? createdAt;

  /// Constructs new `VecturaUser` object.
  const VecturaUser({
    required this.id,
    required this.email,
    this.password,
    required this.name,
    required this.phone,
    this.accessToken,
    this.refreshToken,
    this.vehicle,
    this.createdAt,
  });

  /// Constructs new `VecturaUser` object from [json].
  VecturaUser.fromJson(Map<String, dynamic> json)
      : id = json[VecturaUserJsonKey.id],
        email = json[VecturaUserJsonKey.email],
        password = null,
        name = json[VecturaUserJsonKey.name],
        phone = json[VecturaUserJsonKey.phone],
        accessToken = json[VecturaUserJsonKey.accessToken],
        refreshToken = json[VecturaUserJsonKey.refreshToken],
        createdAt = DateTime.fromMillisecondsSinceEpoch(
            json[VecturaUserJsonKey.createdAt]),
        vehicle = json[VecturaUserJsonKey.vehicle] == null
            ? null
            : VecturaVehicle.fromJson(
                json[VecturaUserJsonKey.vehicle],
              );

  /// Converts this object into json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      VecturaUserJsonKey.id: id,
      VecturaUserJsonKey.email: email,
      if (password != null) VecturaUserJsonKey.password: password,
      VecturaUserJsonKey.name: name,
      VecturaUserJsonKey.phone: phone,
      if (vehicle != null) VecturaUserJsonKey.vehicle: vehicle,
      if (createdAt != null) VecturaUserJsonKey.createdAt: createdAt,
    };
  }

  /// Returns new instance of `VecturaUser` with modified fields.
  VecturaUser copyWith({
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
    return VecturaUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      vehicle: (override == true) ? vehicle : vehicle ?? this.vehicle,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  VecturaUser copyWithTokens({
    required String accessToken,
    required String refreshToken,
  }) {
    return VecturaUser(
      id: id,
      email: email,
      name: name,
      phone: phone,
      accessToken: accessToken,
      refreshToken: refreshToken,
      vehicle: vehicle,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object? other) {
    return other is VecturaDriver && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Keys used in `VecturaUser` json representations.
abstract class VecturaUserJsonKey {
  /// Key for `VecturaUser.id`.
  static const String id = 'id';

  /// Key for `VecturaUser.email`.
  static const String email = 'email';

  /// Key for `VecturaUser.password`.
  static const String password = 'password';

  /// Key for `VecturaUser.name`.
  static const String name = 'name';

  /// Key for `VecturaUser.phone`.
  static const String phone = 'phone';

  /// Key for `VecturaUser.accessToken`.
  static const String accessToken = 'access_token';

  /// Key for `VecturaUser.refreshToken`.
  static const String refreshToken = 'refresh_token';

  static const String newPassword = 'new_password';

  /// Key for `VecturaUser.vehicle`.
  static const String vehicle = 'vehicle';

  /// Key for `VecturaUser.created_at`.
  static const String createdAt = 'created_at';
}
