part of 'splashscreen_bloc.dart';

@immutable
class SplashScreenState {
  final bool initialized;
  final String? pushRoute;
  final bool connection;

  const SplashScreenState({
    required this.initialized,
    required this.pushRoute,
    required this.connection,
  });

  const SplashScreenState.initial()
      : initialized = false,
        pushRoute = null,
        connection = true;

  SplashScreenState copyWith({
    bool? initialized,
    String? pushRoute,
    bool? connection,
  }) {
    return SplashScreenState(
      initialized: initialized ?? this.initialized,
      pushRoute: pushRoute,
      connection: connection ?? this.connection,
    );
  }
}
