import 'package:dev_go/utils/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'app.dart';

void main() async {
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

  runApp(const TokenGoApp());
}
