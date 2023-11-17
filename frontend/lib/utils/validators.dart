import 'package:email_validator/email_validator.dart';

class Validators {
  static String? validateIfNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field can't be empty";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email can't be empty";
    }
    if (!EmailValidator.validate(value)) {
      return "Please enter correct email";
    }
    return null;
  }
}
