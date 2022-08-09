/// Holds route definitions.
abstract class VecServerRoute {
  static const String api = 'api';
  static const String apiAuth = 'auth';
  static const String apiAuthLogin = 'login';
  static const String apiAuthRegister = 'register';
  static const String apiAuthRefresh = 'refresh';

  static const String apiUser = 'user';
  static const String apiUserPassword = 'password';
  static const String apiUserVehicle = 'vehicle';
  static const String apiUserRides = 'rides';
  static const String apiUserRideHistory = 'ride_history';

  static const String apiRides = 'rides';
  static const String apiRidesIdAccept = 'accept';
  static const String apiRidesIdCancel = 'cancel';
  static const String apiRidesIdReview = 'review';

  static const String apiUsers = 'users';
  static const String apiUseridReviews = 'reviews';

  static const String queryParamFilter = 'filter';
  static const String queryParamPage = 'page';
  static const String queryParamLimit = 'limit';
}
