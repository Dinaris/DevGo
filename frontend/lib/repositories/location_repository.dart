import 'package:geolocator/geolocator.dart';

import '../models/custom_location.dart';

const maxAllowedDistanceInMeters = 50;

abstract class ILocationRepository {
  Future<Position> determinePosition();
  Future<CustomLocation> determineCustomLocation();
  Future<double> distanceBetween(Position from, Position to);
  Future<bool> isUserNearbyLocation(CustomLocation restaurantLocation);
}

class LocationRepository implements ILocationRepository {
  @override
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Future<double> distanceBetween(Position from, Position to) async {
    return Geolocator.distanceBetween(
        from.latitude, from.longitude, to.latitude, to.longitude);
  }

  @override
  Future<CustomLocation> determineCustomLocation() async {
    final userPosition = await determinePosition();
    return CustomLocation.fromPosition(userPosition);
  }

  @override
  Future<bool> isUserNearbyLocation(CustomLocation placeLocation) async {
    // TODO: remove hardcoded value - added for the demo purposes
    //CustomLocation userPosition = await determineCustomLocation();
    CustomLocation userPosition = CustomLocation(latitude: 41.0463639, longitude: 28.9889355);
    double distanceInMeters = await distanceBetween(
        Position.fromMap(userPosition.toJson()),
        Position.fromMap(placeLocation.toJson()));
    return distanceInMeters <= maxAllowedDistanceInMeters;
  }
}
