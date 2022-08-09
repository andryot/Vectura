class JwtPair {
  final String accessToken;
  final String refreshToken;

  const JwtPair({required this.refreshToken, required this.accessToken});

  JwtPair.fromJson(Map<String, dynamic> json)
      : accessToken = json[JwtPairJsonKey.accessToken],
        refreshToken = json[JwtPairJsonKey.refreshToken];

  Map<String, Object?> toJson() {
    return <String, Object?>{
      JwtPairJsonKey.accessToken: accessToken,
      JwtPairJsonKey.refreshToken: refreshToken,
    };
  }

  JwtPair copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return JwtPair(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

abstract class JwtPairJsonKey {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
}
