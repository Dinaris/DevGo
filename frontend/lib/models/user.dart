class User {
  const User({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  static var empty = const User(email: "", password: "");
}
