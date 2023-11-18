class UserAuthData {
  UserAuthData({
    required this.isAuthorized,
  });
  late bool isAuthorized;

  UserAuthData.fromJson(Map<String, dynamic> json) {
    isAuthorized = json['isAuthorized'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['isAuthorized'] = isAuthorized;
    return _data;
  }

  static var empty = UserAuthData(isAuthorized: false);
}
