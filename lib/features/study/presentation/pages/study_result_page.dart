import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../statistics/presentation/providers/statistics_provider.dart';
import '../../domain/models/study_result.dart';
import 'study_page.dart';

class StudyResultPage extends StatelessWidget {
  final List<StudyResult> results;
  final List<String> cardIds;

  const StudyResultPage({
    super.key,
    required this.results,
    required this.cardIds,
  });

  int get correctCount => results.where((r) => r.isCorrect).length;
  int get totalCount => results.length;
  bool get isPassed => correctCount == totalCount;

  double get averageSimilarity {
    if (results.isEmpty) return 0;
    final total = results.fold<double>(0, (sum, r) => sum + r.similarity);
    return total / results.length;
  }

  List<StudyResult> get wrongResults =>
      results.where((r) => !r.isCorrect).toList();

  void _onRetry(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => StudyPage(cardIds: cardIds),
      ),
    );
  }

  void _onFinish(BuildContext context) {
    // Refresh dashboard and statistics data before going back
    context.read<DashboardProvider>().refresh();
    context.read<StatisticsProvider>().refresh();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.studyComplete),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummaryCard(theme, l10n),
            const SizedBox(height: 24),

            if (wrongResults.isNotEmpty) ...[
              _buildWrongAnswersSection(theme, l10n),
              const SizedBox(height: 24),
            ],

            FilledButton(
              onPressed: () => _onRetry(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(l10n.studyAgain),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => _onFinish(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(l10n.backToHome),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme, AppLocalizations l10n) {
    final color = isPassed ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            ResultImage(
              isCorrect: isPassed,
              similarity: averageSimilarity,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              '${(averageSimilarity * 100).toInt()}%',
              style: theme.textTheme.displayLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.similarityScore,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$correctCount / $totalCount',
              style: theme.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWrongAnswersSection(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.wrongAnswers,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...wrongResults.map((result) => _buildWrongAnswerItem(theme, l10n, result)),
      ],
    );
  }

  Widget _buildWrongAnswerItem(
      ThemeData theme, AppLocalizations l10n, StudyResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.correctAnswer,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.red.shade400,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    result.userAnswer.isEmpty
                        ? l10n.emptyAnswer
                        : result.userAnswer,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red.shade400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
