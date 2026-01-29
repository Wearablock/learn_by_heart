import 'package:flutter/material.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../card/data/models/memory_card.dart';
import '../../../study/presentation/pages/study_page.dart';

class RecentCardWidget extends StatelessWidget {
  final MemoryCard? card;

  const RecentCardWidget({super.key, this.card});

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
              l10n.recentlyStudied,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (card == null)
              Row(
                children: [
                  EmptyStateImage(
                    assetPath: AppImages.emptyStudy,
                    fallbackIcon: Icons.history,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.noRecentStudy,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              )
            else ...[
              Text(
                card!.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _navigateToStudy(context),
                  child: Text(l10n.startStudy),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToStudy(BuildContext context) {
    if (card == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudyPage(cardIds: [card!.id]),
      ),
    );
  }
}
