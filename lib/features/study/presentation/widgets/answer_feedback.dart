import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class AnswerFeedback extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final String? userAnswer;
  final VoidCallback onNext;

  const AnswerFeedback({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
    this.userAnswer,
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
        // 정답/오답 표시
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
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 정답 표시
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

        // 오답인 경우 사용자 답변 표시
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

        // 다음 버튼
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
}
