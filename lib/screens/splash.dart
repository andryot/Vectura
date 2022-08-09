import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/splash_screen/splashscreen_bloc.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/keychain_service.dart';
import '../services/local_storage_service.dart';
import '../style/colors.dart';
import '../style/images.dart';
import 'sign_in.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashScreenBloc>(
      create: (BuildContext context) => SplashScreenBloc(
        keychainService: KeychainService.instance,
        globalBloc: GlobalBloc.instance,
        authService: AuthService.instance,
        connectivityService: ConnectivityService.instance,
        localStorageService: LocalStorageService.instance,
      ),
      child: const _SplashScreen(),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashScreenBloc, SplashScreenState>(
        listener: (context, state) {
      if (state.initialized) {
        Navigator.pushReplacementNamed(
          context,
          state.pushRoute!,
          arguments: const SignInScreenArgs(
            email: '',
            password: '',
          ),
        );
        return;
      } else if (!state.connection) {
        showCupertinoDialog(
          context: context,
          builder: (builder) {
            return CupertinoAlertDialog(
              title: const Text("No internet connection"),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text("Retry"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    BlocProvider.of<SplashScreenBloc>(context).retry();
                  },
                )
              ],
            );
          },
        );
      }
    }, builder: (context, state) {
      return CupertinoPageScaffold(
        child: Center(
          child: Hero(
            tag: 'logo',
            child: SvgPicture.asset(
              VecImage.logo,
              color: VecColor.primaryColor(context),
            ),
          ),
        ),
      );
    });
  }
}
