import 'package:flutter/material.dart';

/// 이미지 에셋 경로 상수
class AppImages {
  AppImages._();

  // Empty states
  static const String emptyCards = 'assets/images/empty_cards.png';
  static const String emptyStudy = 'assets/images/empty_study.png';
  static const String emptyStats = 'assets/images/empty_stats.png';

  // Study results
  static const String resultPerfect = 'assets/images/result_perfect.png';
  static const String resultGood = 'assets/images/result_good.png';
  static const String resultTryAgain = 'assets/images/result_try.png';

  // Dashboard
  static const String streakFire = 'assets/images/streak_fire.png';
  static const String mascot = 'assets/images/mascot.png';
  static const String dueCards = 'assets/images/due_cards.png';

  // Onboarding
  static const String onboarding1 = 'assets/images/onboarding/step1.png';
  static const String onboarding2 = 'assets/images/onboarding/step2.png';
  static const String onboarding3 = 'assets/images/onboarding/step3.png';
}

/// 이미지가 없을 때 fallback 아이콘을 표시하는 위젯
class AppImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? fallback;
  final Color? color;

  const AppImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.fallback,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return fallback ?? SizedBox(width: width, height: height);
      },
    );
  }
}

/// Empty State용 일러스트 위젯
class EmptyStateImage extends StatelessWidget {
  final String assetPath;
  final IconData fallbackIcon;
  final double size;
  final Color? color;

  const EmptyStateImage({
    super.key,
    required this.assetPath,
    required this.fallbackIcon,
    this.size = 120,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = color ?? theme.colorScheme.primary.withValues(alpha: 0.5);

    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          fallbackIcon,
          size: size,
          color: iconColor,
        );
      },
    );
  }
}

/// 결과 화면용 일러스트 위젯
class ResultImage extends StatelessWidget {
  final bool isCorrect;
  final double? similarity;
  final double size;

  const ResultImage({
    super.key,
    required this.isCorrect,
    this.similarity,
    this.size = 80,
  });

  String get _assetPath {
    if (isCorrect) {
      if (similarity != null && similarity! >= 0.95) {
        return AppImages.resultPerfect;
      }
      return AppImages.resultGood;
    }
    return AppImages.resultTryAgain;
  }

  IconData get _fallbackIcon {
    if (isCorrect) {
      if (similarity != null && similarity! >= 0.95) {
        return Icons.celebration;
      }
      return Icons.check_circle;
    }
    return Icons.sentiment_dissatisfied;
  }

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? Colors.green : Colors.red;

    return Image.asset(
      _assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          _fallbackIcon,
          size: size,
          color: color,
        );
      },
    );
  }
}
