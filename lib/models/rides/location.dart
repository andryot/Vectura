/// Model representing base user info.
class VecturaLocation {
  /// The title of the location.
  final String title;

  /// The latitude of the location.
  final double lat;

  /// The longitude of the location.
  final double lng;

  /// Constructs new `VecturaLocation` object.
  const VecturaLocation({
    required this.title,
    required this.lat,
    required this.lng,
  });

  /// Constructs new `VecturaLocation` object from [json].
  VecturaLocation.fromJson(Map<String, dynamic> json)
      : title = json[VecturaLocationJsonKey.title],
        lat = json[VecturaLocationJsonKey.lat],
        lng = json[VecturaLocationJsonKey.lng];

  /// Converts this object into json representation.
  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      VecturaLocationJsonKey.title: title,
      VecturaLocationJsonKey.lat: lat,
      VecturaLocationJsonKey.lng: lng,
    };
  }

  /// Returns new instance of `VecturaLocation` with modified fields.
  VecturaLocation copyWith({
    String? title,
    double? lat,
    double? lng,
  }) {
    return VecturaLocation(
      title: title ?? this.title,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}

/// Keys used in `VecturaLocation` json representations.
abstract class VecturaLocationJsonKey {
  /// Key for `VecturaLocation.title`.
  static const String title = 'title';

  /// Key for `VecturaLocation.lat`.
  static const String lat = 'lat';

  /// Key for `VecturaLocation.lng`.
  static const String lng = 'lng';
}
