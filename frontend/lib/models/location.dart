class Location {
  Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  });
  late final num id;
  late final String name;
  late final num latitude;
  late final num longitude;
  late final String imageUrl;

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['image_url'] = imageUrl;
    return _data;
  }

  static var empty = Location(
    id: 0,
    name: "",
    latitude: 0.0,
    longitude: 0.0,
    imageUrl: "",
  );
}
