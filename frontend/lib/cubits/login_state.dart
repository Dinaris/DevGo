part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final String error;
  final bool isLoading;
  final bool isAuthorized;

  const LoginState({
    this.email = "",
    this.password = "",
    this.error = "",
    this.isLoading = false,
    this.isAuthorized = false,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    error,
    isLoading,
    isAuthorized,
  ];

  LoginState copyWith({
    String? email,
    String? password,
    String? error,
    bool? isLoading,
    bool? isAuthorized
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isAuthorized: isAuthorized ?? this.isAuthorized,
    );
  }
}
