import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class AnswerFeedback extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final String? userAnswer;
  final double? similarity;
  final VoidCallback onNext;

  const AnswerFeedback({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
    this.userAnswer,
    this.similarity,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final color = isCorrect ? Colors.green : Colors.red;
    final icon = isCorrect ? Icons.check_circle : Icons.cancel;
    final message = isCorrect ? l10n.correct : l10n.incorrect;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Result indicator
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, size: 64, color: color),
              const SizedBox(height: 12),
              Text(
                message,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Similarity score
              if (similarity != null) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.similarityScore,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(similarity! * 100).round()}%',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: _getSimilarityColor(similarity!),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: similarity,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: _getSimilarityColor(similarity!),
                    minHeight: 8,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Correct answer
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.correctAnswerLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  correctAnswer,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),

        // User answer (if incorrect)
        if (!isCorrect && userAnswer != null && userAnswer!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Card(
            color: Colors.red.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.yourAnswer,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userAnswer!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),

        // Next button
        FilledButton(
          onPressed: onNext,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(l10n.next),
          ),
        ),
      ],
    );
  }

  Color _getSimilarityColor(double similarity) {
    if (similarity >= 0.8) return Colors.green;
    if (similarity >= 0.6) return Colors.orange;
    return Colors.red;
  }
}
