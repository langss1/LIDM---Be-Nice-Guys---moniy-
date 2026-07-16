import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryBlue,
      textTheme: AppTypography.textTheme,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
    );
  }
}
