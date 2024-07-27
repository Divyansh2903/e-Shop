import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF0C54BE);
  static const Color secondaryColor = Color(0xFF303F60);
  static const Color backgroundColor = Color(0xFFF5F9FD);
  static const Color surfaceColor = Color(0xFFCED3DC);
  static const Color dropShadow = Color.fromRGBO(183, 99, 99, 0.11);
  static BoxShadow dropShadowDecoration = BoxShadow(
    color: dropShadow.withOpacity(0.1),
    spreadRadius: 2,
    blurRadius: 10,
    offset: const Offset(6, 8),
  );
}
