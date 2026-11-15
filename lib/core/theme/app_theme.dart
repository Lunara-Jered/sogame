import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.yellow,
          primary: AppColors.yellow,
          onPrimary: Colors.black,
          surface: AppColors.background,
        ),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Barlow Condensed',
            fontWeight: FontWeight.w800,
            color: AppColors.foreground,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Barlow Condensed',
            fontWeight: FontWeight.w800,
            color: AppColors.foreground,
          ),
          bodyLarge: TextStyle(color: AppColors.foreground),
          bodyMedium: TextStyle(color: AppColors.foreground),
        ),
      );
}
