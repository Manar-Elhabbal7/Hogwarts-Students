import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle titlePrimary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleSecondary = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyRegular = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );

  static const TextStyle hintStyle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.1,
  );

  static const TextStyle textLink = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
  );
}
