import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/study_result.dart';

class StudyResultPage extends StatelessWidget {
  final List<StudyResult> results;
  final VoidCallback onRetry;
  final VoidCallback onFinish;

  const StudyResultPage({
    super.key,
    required this.results,
    required this.onRetry,
    required this.onFinish,
  });

  int get correctCount => results.where((r) => r.isCorrect).length;
  int get totalCount => results.length;
  double get accuracy => totalCount > 0 ? correctCount / totalCount : 0;

  List<StudyResult> get wrongResults =>
      results.where((r) => !r.isCorrect).toList();

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
            // 결과 요약
            _buildSummaryCard(theme, l10n),
            const SizedBox(height: 24),

            // 틀린 문제 목록
            if (wrongResults.isNotEmpty) ...[
              _buildWrongAnswersSection(theme, l10n),
              const SizedBox(height: 24),
            ],

            // 버튼들
            FilledButton(
              onPressed: onRetry,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(l10n.studyAgain),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onFinish,
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
    final color = _getAccuracyColor(accuracy);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              accuracy >= 0.8
                  ? Icons.celebration
                  : accuracy >= 0.5
                      ? Icons.thumb_up
                      : Icons.sentiment_dissatisfied,
              size: 64,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              '${(accuracy * 100).toInt()}%',
              style: theme.textTheme.displayLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.accuracy,
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

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.5) return Colors.orange;
    return Colors.red;
  }
}
