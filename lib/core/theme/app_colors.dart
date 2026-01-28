import 'package:flutter/material.dart';

/// 앱 색상 정의 - 코랄/오렌지 테마
///
/// "Learn by Heart"의 Heart와 어울리는 따뜻하고 열정적인 색상
class AppColors {
  AppColors._();

  // Primary - 코랄 핑크
  static const Color primary = Color(0xFFFF7675);
  static const Color primaryDark = Color(0xFFE17055);
  static const Color primaryLight = Color(0xFFFFAB91);

  // Secondary - 웜 오렌지
  static const Color secondary = Color(0xFFE17055);
  static const Color secondaryLight = Color(0xFFFFCCBC);

  // Accent - 피치
  static const Color accent = Color(0xFFFFB74D);

  // Surface colors
  static const Color surfaceLight = Color(0xFFFFFBFA);
  static const Color surfaceDark = Color(0xFF1A1A1A);

  // On colors (대비 색상)
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;

  // Feedback colors
  static const Color correct = Color(0xFF4CAF50);
  static const Color wrong = Color(0xFFE53935);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
}
