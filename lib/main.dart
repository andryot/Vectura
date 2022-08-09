import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/global/global_bloc.dart';
import 'router/router.dart';
import 'router/routes.dart';
import 'services/auth_service.dart';
import 'services/backend_service.dart';
import 'services/connectivity_service.dart';
import 'services/http_service.dart';
import 'services/image_picker_service.dart';
import 'services/keychain_service.dart';
import 'services/local_storage_service.dart';
import 'style/theme.dart';
import 'util/logger.dart';

void main() {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final Logger logger = Logger();
  KeychainService();

  final HttpService httpService = HttpService();
  AuthService(httpService: httpService);
  BackendService(httpService: httpService);
  ImagePickerService(imagePicker: ImagePicker());
  LocalStorageService();

  ConnectivityService();

  final GlobalBloc globalBloc = GlobalBloc(logger: logger);

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  runApp(VecturaApp(navigatorKey: navigatorKey));
}

class VecturaApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const VecturaApp({
    Key? key,
    required this.navigatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return CupertinoApp(
      title: 'Vectura',
      theme: vecTheme,
      initialRoute: VecRoute.initial,
      onGenerateRoute: VecRouter.onGenerateRoute,
      navigatorKey: navigatorKey,
      localizationsDelegates: [
        // Import material localization to display native android date picker
        if (Platform.isAndroid) DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
