import 'package:dev_go/components/custom_text_form_field.dart';
import 'package:dev_go/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/constants.dart';
import '../utils/size_config.dart';
import '../utils/validators.dart';

class LoginScreen extends StatelessWidget {
  final _signUpFormKey = GlobalKey<FormState>();

  TextStyle hintStyle = GoogleFonts.nunito(
      color: kTextLightColor2, fontSize: 18, fontWeight: FontWeight.w400);

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Form(
        key: _signUpFormKey,
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
                  _buildEmailField(),
                  const SizedBox(height: 25),
                  _buildPasswordField(),
                  const SizedBox(height: 25),
                  Expanded(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildLoginButton(context),
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

  _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email",
            style: GoogleFonts.nunito(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600
            )),
        const SizedBox(height: 10),
        CustomTextFormField(
            //initialValue: ,
            hintText: "Your Email",
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            onChanged: (value) {

            }
        ),
      ],
    );
  }

  _buildPasswordField() {
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
            keyboardType: TextInputType.visiblePassword,
            validator: Validators.validateIfNotEmpty,
            onChanged: (value) {

            }
        ),
      ],
    );
  }

  _buildLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () async {

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
