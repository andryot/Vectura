/// Model representing base user info.
class VecturaReview {
  /// The stars of the review.
  final int stars;

  /// The comment of the review.
  final String comment;

  /// The name of the user.
  final String? userName;

  /// Constructs new `VecturaReview` object.
  const VecturaReview({
    required this.stars,
    required this.comment,
    this.userName,
  });

  /// Constructs new `VecturaReview` object from [json].
  VecturaReview.fromJson(Map<String, dynamic> json)
      : stars = json[VecturaReviewJsonKey.stars],
        comment = json[VecturaReviewJsonKey.comment],
        userName = json[VecturaReviewJsonKey.userName];

  /// Converts this object into json representation.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      VecturaReviewJsonKey.stars: stars,
      VecturaReviewJsonKey.comment: comment,
      VecturaReviewJsonKey.userName: userName,
    };
  }

  /// Returns new instance of `VecturaReview` with modified fields.
  VecturaReview copyWith({
    int? stars,
    String? comment,
    String? userName,
  }) {
    return VecturaReview(
      stars: stars ?? this.stars,
      comment: comment ?? this.comment,
      userName: userName ?? this.userName,
    );
  }
}

/// Keys used in `VecturaReview` json representations.
abstract class VecturaReviewJsonKey {
  /// Key for `VecturaReview.title`.
  static const String stars = 'stars';

  /// Key for `VecturaReview.lat`.
  static const String comment = 'comment';

  /// Key for `VecturaReview.userName`.
  static const String userName = 'user_name';
}
