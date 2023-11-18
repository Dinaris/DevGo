import 'dart:async';

import '../models/login_request.dart';
import '../models/user.dart';
import '../models/user_auth_data.dart';

const users = [
  User(email: "user1@example.com", password: "user1"),
  User(email: "user2@example.com", password: "user2"),
];

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository();

  Future<UserAuthData> login(LoginRequest request) async {
    final user = users.firstWhere(
      (user) => user.email == request.email
          && user.password == request.password,
      orElse: () => User.empty);
    return UserAuthData(isAuthorized: user.email.isNotEmpty
        && user.email == request.email);
  }
}
