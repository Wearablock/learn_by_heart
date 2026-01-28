import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class StudyCard extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final bool enabled;

  const StudyCard({
    super.key,
    this.hint,
    required this.controller,
    required this.onSubmit,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hint != null && hint!.isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.cardHint,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hint!,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
        TextField(
          controller: controller,
          enabled: enabled,
          autofocus: true,
          maxLines: 5,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(
            labelText: l10n.enterAnswer,
            alignLabelWithHint: true,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: enabled ? onSubmit : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(l10n.submit),
          ),
        ),
      ],
    );
  }
}
