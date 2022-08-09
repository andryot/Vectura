/// Defines all possible routes for Vectura app.
abstract class VecRoute {
  static const String initial = '/';
  static const String signIn = '/signIn';
  static const String registration = '/registration';
  static const String root = '/root';
  static const String home = '/home';
  static const String search = '/search';
  static const String history = '/history';
  static const String profile = '/profile';
  static const List<String> tabNames = [home, search, history, profile];
  static const String offerRide = '/offer';
  static const String offerDetails = '/details';
  static const String vehicle = '/vehicle';
  static const String userInfo = '/userInfo';
  static const String changePassword = '/changePassword';
}
