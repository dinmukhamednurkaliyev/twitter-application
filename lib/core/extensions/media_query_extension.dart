import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isDarkMode =>
      MediaQuery.of(this).platformBrightness == Brightness.dark;
}
