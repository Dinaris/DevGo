class UserHistoryResponse {
  late final List<UserHistory> data;

  UserHistoryResponse({required this.data});

  UserHistoryResponse.fromJson(List<dynamic>? json) {
    if (json != null) {
      data = List.from(json)
          .map((e) => UserHistory.fromJson(e)).toList();
    } else {
      data = List.empty();
    }
  }
}

class UserHistory {
  late final num id;
  late final String name;
  late final num latitude;
  late final num longitude;
  late final String imageUrl;
  late final num visited;
  late final num isOG;

  UserHistory({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.visited,
    required this.isOG,
  });

  UserHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['lat'];
    longitude = json['lon'];
    imageUrl = json['IMG_URL'] ?? "";
    visited = json['visited'] ?? 0;
    isOG = json['isOG'] ?? 0;
  }
}
