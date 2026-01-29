import 'package:flutter/material.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../l10n/app_localizations.dart';

class StreakWidget extends StatelessWidget {
  final int streak;

  const StreakWidget({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (streak <= 0) {
      return const SizedBox.shrink();
    }

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AppImage(
              assetPath: AppImages.streakFire,
              width: 40,
              height: 40,
              fallback: Icon(
                Icons.local_fire_department,
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.dashboardStreak(streak),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
