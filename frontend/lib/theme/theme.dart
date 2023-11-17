import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: kPrimaryDefaultBgColor,
    fontFamily: "Raleway",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    bottomNavigationBarTheme:
    const BottomNavigationBarThemeData(backgroundColor: kPrimaryColor),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: kPrimaryTextColor,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder focusOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: kAccentColor, width: 1),
  );
  OutlineInputBorder outOfFocusOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: kUnfocusBorderColor, width: 1),
  );
  return InputDecorationTheme(
    border: outOfFocusOutlineInputBorder,
    enabledBorder: outOfFocusOutlineInputBorder,
    focusedBorder: focusOutlineInputBorder,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    filled: true,
    fillColor: kPrimaryDefaultBgColor,
    hintStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: kPrimaryInputHintTextColor),
  );
}

TextTheme textTheme() {
  return TextTheme(
      overline: TextStyle(
          color: kPrimaryTextColor.withOpacity(0.38),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5),
      button: const TextStyle(
          color: kPrimaryDefaultBgColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25),
      headline4: const TextStyle(
          color: kPrimaryTextColor,
          fontSize: 34,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.18),
      headline5: const TextStyle(
          color: kPrimaryTextColor,
          fontSize: 24,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.18),
      headline6: const TextStyle(
          color: kPrimaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.18),
      caption: const TextStyle(
          color: kPrimaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.4),
      subtitle1: const TextStyle(
          color: kPrimaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15),
      subtitle2: const TextStyle(
          color: kPrimaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1),
      bodyText1: const TextStyle(
          color: kPrimaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4),
      bodyText2: const TextStyle(
          color: kPrimaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4));
}
