import 'package:geolocator/geolocator.dart';

class CustomLocation {
  CustomLocation({
    required this.latitude,
    required this.longitude,
  });

  late final double latitude;
  late final double longitude;

  CustomLocation.fromPosition(Position position) {
    latitude = position.latitude;
    longitude = position.longitude;
  }

  CustomLocation.withLatLng({required this.latitude, required this.longitude});

  CustomLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }

  static var empty = CustomLocation(
    latitude: 0.0,
    longitude: 0.0,
  );
}
