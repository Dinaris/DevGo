import 'package:dev_go/components/custom_text_form_field.dart';
import 'package:dev_go/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cubits/login_cubit.dart';
import '../theme/constants.dart';
import '../utils/size_config.dart';
import '../utils/validators.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  TextStyle hintStyle = GoogleFonts.nunito(
      color: kTextLightColor2, fontSize: 18, fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Form(
        key: _loginFormKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 65.0, right: 25.0, bottom: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMessage(hintStyle),
                  _buildEmailField(loginCubit),
                  const SizedBox(height: 25),
                  _buildPasswordField(loginCubit),
                  const SizedBox(height: 25),
                  Expanded(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildLoginButton(loginCubit),
                            ],
                          )
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildEmailField(LoginCubit loginCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email",
            style: GoogleFonts.nunito(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600
            )),
        const SizedBox(height: 10),
        CustomTextFormField(
            //initialValue: loginCubit.state.email,
            hintText: "Your Email",
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            onChanged: (value) {
              loginCubit.onEmailChange(value);
            }
        ),
      ],
    );
  }

  _buildPasswordField(LoginCubit loginCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password",
            style: GoogleFonts.nunito(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600
            )),
        const SizedBox(height: 10),
        CustomTextFormField(
            hintText: "Password",
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            validator: Validators.validateIfNotEmpty,
            onChanged: (value) {
              loginCubit.onPasswordChange(value);
            }
        ),
      ],
    );
  }

  _buildMessage(TextStyle style) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => (previous != current),
      builder: (context, state) {
        if (state.error.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Text(state.error,
                style: style.copyWith(color: Colors.red)),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  _buildLoginButton(LoginCubit loginCubit) {
    return TextButton(
      onPressed: () async {
        if (!_loginFormKey.currentState!.validate()) {
          return;
        }
        if (await loginCubit.onLogin()) {

        }
      },
      child: RoundedButton(
          width: double.infinity,
          height: getProportionateScreenHeight(60.0),
          text: "Login",
          textStyle: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700),
          color: kPrimaryTextColor2,
          textColor: Colors.white,
          borderRadius: getProportionateScreenWidth(10.0)
      ),
    );
  }
}
