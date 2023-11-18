import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/login_request.dart';
import '../repositories/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const LoginState());

  void onEmailChange(String value) {
    emit(state.copyWith(email: value));
    print("@@@ email: ${state.email}");
  }

  void onPasswordChange(String value) {
    emit(state.copyWith(password: value));
    print("@@@ password: ${state.password}");
  }

  Future<bool> onLogin() async {
    try {
      LoginRequest request = LoginRequest(
        email: state.email,
        password: state.password
      );

      emit(state.copyWith(isLoading: true));

      var loginResponse =
        await _authenticationRepository.login(request);

      emit(state.copyWith(
          isLoading: false,
          error: loginResponse.isAuthorized
              ? ""
              : "Wrong email or password. Please try again",
          isAuthorized: loginResponse.isAuthorized));

      return loginResponse.isAuthorized;
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          error: "Error during login. Please try again",
          isAuthorized: false));
    }
    return false;
  }
}
