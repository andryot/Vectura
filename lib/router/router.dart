import 'package:flutter/cupertino.dart';

import '../bloc/global/global_bloc.dart';
import '../screens/change_password.dart';
import '../screens/offer_details.dart';
import '../screens/offer_ride.dart';
import '../screens/registration.dart';
import '../screens/root.dart';
import '../screens/sign_in.dart';
import '../screens/splash.dart';
import '../screens/tabs/history.dart';
import '../screens/tabs/home.dart';
import '../screens/tabs/profile.dart';
import '../screens/tabs/search.dart';
import '../screens/user_info.dart';
import '../screens/vehicle.dart';
import '../services/image_picker_service.dart';
import '../services/local_storage_service.dart';
import '../util/logger.dart';
import 'routes.dart';

/// Provides [onGenerateRoute] function and stores current topmost route.
abstract class VecRouter {
  /// Transforms [settings] into corresponding route.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Logger.instance.info(
      'VecturaRouter.onGenerateRoute',
      'pushing route ${settings.name}',
    );

    switch (settings.name) {
      case VecRoute.initial:
        return CupertinoPageRoute(builder: (context) => const SplashScreen());
      case VecRoute.signIn:
        return PageRouteBuilder(
          pageBuilder: (context, _, __) => SignInScreen(
            args: settings.arguments as SignInScreenArgs,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 850),
        );
      case VecRoute.registration:
        return PageRouteBuilder(
          pageBuilder: (context, _, __) => RegistrationScreen(
            args: settings.arguments as RegistrationScreenArgs,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 850),
        );
      case VecRoute.root:
        return PageRouteBuilder(
          pageBuilder: (context, _, __) => const RootScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );

      case VecRoute.home:
        return PageRouteBuilder(
          fullscreenDialog: true,
          reverseTransitionDuration: const Duration(milliseconds: 0),
          transitionDuration: const Duration(milliseconds: 0),
          pageBuilder: (context, _, __) => const HomeTab(),
        );
      case VecRoute.search:
        return PageRouteBuilder(
          fullscreenDialog: true,
          reverseTransitionDuration: const Duration(milliseconds: 0),
          transitionDuration: const Duration(milliseconds: 0),
          pageBuilder: (context, _, __) => const SearchTab(),
        );
      case VecRoute.history:
        return PageRouteBuilder(
          fullscreenDialog: true,
          reverseTransitionDuration: const Duration(milliseconds: 0),
          transitionDuration: const Duration(milliseconds: 0),
          pageBuilder: (context, _, __) => const HistoryTab(),
        );
      case VecRoute.profile:
        return PageRouteBuilder(
          fullscreenDialog: true,
          reverseTransitionDuration: const Duration(milliseconds: 0),
          transitionDuration: const Duration(milliseconds: 0),
          pageBuilder: (context, _, __) => const ProfileTab(),
        );
      case VecRoute.offerRide:
        return CupertinoPageRoute(
          builder: (context) => const OfferRideScreen(),
        );

      case VecRoute.offerDetails:
        return CupertinoPageRoute(
          builder: (context) => OfferDetailsScreen(rideId: settings.arguments),
        );
      case VecRoute.vehicle:
        return CupertinoPageRoute(
          builder: (context) => const VehicleScreen(),
        );
      case VecRoute.userInfo:
        return CupertinoPageRoute(
          builder: (context) => UserInfoScreen(
            imagePickerService: ImagePickerService.instance,
            localStorageService: LocalStorageService.instance,
            globalBloc: GlobalBloc.instance,
          ),
        );
      case VecRoute.changePassword:
        return CupertinoPageRoute(
          builder: (context) => const ChangePasswordScreen(),
        );
    }

    return null;
  }
}
