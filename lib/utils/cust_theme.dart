import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_app/consts/colors.dart';

class CustomThemes {
  static final lightTheme = ThemeData(
      dividerColor: Vx.gray800,
      cardColor: Colors.white,
      fontFamily: 'poppins',
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Vx.gray800,
      iconTheme: const IconThemeData(color: Vx.gray600));
  static final darkTheme = ThemeData(
      dividerColor: Colors.white.withOpacity(0.4),
      cardColor: bgColor.withOpacity(0.8),
      fontFamily: 'poppins',
      scaffoldBackgroundColor: bgColor,
      primaryColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white));
}
