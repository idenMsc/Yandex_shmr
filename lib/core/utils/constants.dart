import 'package:flutter/material.dart';

const baseUrl = 'https://shmr-finance.ru/api/v1';
const token = 'QAv0gBBhHLwYXHZBDt4MR6Kr';

// Цвета
class AppColors {
  static const surface = Color(0xFFFEF7FF);
  static const onSurface = Color(0xFF1D1B20);
  static const onSurfaceVariant = Color(0xFF49454F);
  static const primary = Color(0xFF2AE881);
  static const primaryContainer = Color(0xFFD4FAE6);
  static const surfaceContainer = Color(0xFFF3EDF7);
  static const tertiary = Color(0xFF3C3C43);
  static const outlineVariant = Color(0xFFCAC4D0);
  static const error = Color(0xFFE46962);
  static const onPrimary = Color(0xFFFFFFFF);
}

// Размеры
class AppSizes {
  static const double appBarHeight = 64.0;
  static const double bottomNavBarHeight = 80.0;
  static const double avatarRadius = 12.0;
  static const double listTilePaddingH = 16.0;
  static const double listTilePaddingV = 11.0;
  static const double iconSize = 32.0;
  static const double navBarBorderRadius = 20.0;
}

// Текстовые стили
class AppTextStyles {
  static const titleLarge = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    color: AppColors.onSurface,
    fontWeight: FontWeight.w400,
  );
  static const labelMedium = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.onSurfaceVariant,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  static const bodyLarge = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    color: AppColors.onSurface,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );
  static const bodyMedium = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    color: AppColors.onSurfaceVariant,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
}
