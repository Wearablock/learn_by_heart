import 'package:flutter/material.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../study/presentation/pages/study_page.dart';

class DueCardsWidget extends StatelessWidget {
  final int dueCount;
  final List<String> cardIds;

  const DueCardsWidget({
    super.key,
    required this.dueCount,
    required this.cardIds,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dueForReview,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                AppImage(
                  assetPath: AppImages.dueCards,
                  width: 32,
                  height: 32,
                  fallback: Icon(
                    Icons.schedule,
                    color: dueCount > 0
                        ? theme.colorScheme.error
                        : theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.cardsDueCount(dueCount),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            if (dueCount > 0) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _startStudyAll(context),
                  child: Text(l10n.startStudyAll),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _startStudyAll(BuildContext context) {
    if (cardIds.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudyPage(cardIds: cardIds),
      ),
    );
  }
}
