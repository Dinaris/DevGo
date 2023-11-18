List<Location> locations = [
  Location(id: 1, name: "Istanbul Congress Center", latitude: 41.0463638, longitude: 28.9889354),
  Location(id: 2, name: "Taksim Square", latitude: 41.037666, longitude: 28.9848298),
  Location(id: 3, name: "Galata Tower", latitude: 41.0256299, longitude: 28.9731427),
];

class Location {
  Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
  late final num id;
  late final String name;
  late final num latitude;
  late final num longitude;

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }

  static var empty = Location(
    id: 0,
    name: "",
    latitude: 0.0,
    longitude: 0.0,
  );
}
