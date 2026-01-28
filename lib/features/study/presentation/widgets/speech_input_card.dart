import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class SpeechInputCard extends StatelessWidget {
  final String? hint;
  final String recognizedText;
  final bool isListening;
  final TextEditingController controller;
  final VoidCallback onMicPressed;
  final VoidCallback onSubmit;
  final bool showTextField;
  final VoidCallback onToggleTextField;

  const SpeechInputCard({
    super.key,
    this.hint,
    required this.recognizedText,
    required this.isListening,
    required this.controller,
    required this.onMicPressed,
    required this.onSubmit,
    required this.showTextField,
    required this.onToggleTextField,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hint card
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

        // Recognized text display
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      size: 18,
                      color: isListening
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isListening ? l10n.listening : l10n.yourAnswer,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isListening
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 80),
                  child: Text(
                    recognizedText.isEmpty
                        ? (isListening ? '...' : l10n.tapMicToSpeak)
                        : recognizedText,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontStyle: recognizedText.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                      color: recognizedText.isEmpty
                          ? theme.colorScheme.onSurfaceVariant
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Mic button
        Center(
          child: GestureDetector(
            onTap: onMicPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isListening
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isListening
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: isListening ? 20 : 10,
                    spreadRadius: isListening ? 5 : 2,
                  ),
                ],
              ),
              child: Icon(
                isListening ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            isListening ? l10n.listening : l10n.tapMicToSpeak,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Toggle typing button
        TextButton.icon(
          onPressed: onToggleTextField,
          icon: Icon(showTextField ? Icons.keyboard_hide : Icons.keyboard),
          label: Text(showTextField ? l10n.hideKeyboard : l10n.typeInstead),
        ),

        // Text field (optional)
        if (showTextField) ...[
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.enterAnswer,
              alignLabelWithHint: true,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
        const SizedBox(height: 24),

        // Submit button
        FilledButton(
          onPressed: (recognizedText.isNotEmpty || controller.text.isNotEmpty)
              ? onSubmit
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(l10n.submit),
          ),
        ),
      ],
    );
  }
}
