import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dev_go/utils/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'app.dart';
import 'app_block_observer.dart';
import 'repositories/authentication_repository.dart';

void bootstrap() async {
  await runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Disable landscape mode
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Use latest renderer for Google Maps
      try {
        AndroidMapRenderer mapRenderer = AndroidMapRenderer.platformDefault;
        final GoogleMapsFlutterPlatform mapsImplementation =
            GoogleMapsFlutterPlatform.instance;
        if (mapsImplementation is GoogleMapsFlutterAndroid) {
          WidgetsFlutterBinding.ensureInitialized();
          mapRenderer = await mapsImplementation
              .initializeWithRenderer(AndroidMapRenderer.latest);
        }
      } catch (e) {}

      // Initialize repositories/helpers here
      await CacheHelper.init();
      final AuthenticationRepository authenticationRepository =
        AuthenticationRepository();
      //DioClient _dioClient = DioClient();
      //Dio _client = _dioClient.init();

      await BlocOverrides.runZoned(
            () async => runApp(App(
          authRepository: authenticationRepository,
        )),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      print("runZonedGuarded ERROR: ${error.toString()}\n"
          "STACKTRACE:\n$stackTrace");
    },
  );
}
