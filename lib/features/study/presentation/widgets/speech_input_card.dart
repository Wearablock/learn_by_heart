import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class SpeechInputCard extends StatefulWidget {
  final String? hint;
  final bool isListening;
  final TextEditingController controller;
  final VoidCallback onMicPressed;
  final VoidCallback onSubmit;
  final VoidCallback? onTypingStarted;

  const SpeechInputCard({
    super.key,
    this.hint,
    required this.isListening,
    required this.controller,
    required this.onMicPressed,
    required this.onSubmit,
    this.onTypingStarted,
  });

  @override
  State<SpeechInputCard> createState() => _SpeechInputCardState();
}

class _SpeechInputCardState extends State<SpeechInputCard> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && widget.isListening) {
      // Typing started while recording - stop recording
      widget.onTypingStarted?.call();
    }
  }

  void _onMicPressed() {
    // Dismiss keyboard when mic is pressed
    _focusNode.unfocus();
    widget.onMicPressed();
  }

  void _dismissKeyboard() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hint card
        if (widget.hint != null && widget.hint!.isNotEmpty) ...[
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
                    widget.hint!,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Combined input card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      widget.isListening ? Icons.mic : Icons.edit_note,
                      size: 18,
                      color: widget.isListening
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.isListening ? l10n.listening : l10n.yourAnswer,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: widget.isListening
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (widget.isListening) ...[
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                    if (_focusNode.hasFocus) ...[
                      IconButton(
                        onPressed: _dismissKeyboard,
                        icon: const Icon(Icons.keyboard_hide),
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                        tooltip: l10n.hideKeyboard,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  maxLines: 4,
                  minLines: 3,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _dismissKeyboard(),
                  decoration: InputDecoration(
                    hintText: l10n.tapMicOrType,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.isListening
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerLow,
                  ),
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Mic button
        Center(
          child: GestureDetector(
            onTap: _onMicPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: widget.isListening
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (widget.isListening
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: widget.isListening ? 20 : 10,
                    spreadRadius: widget.isListening ? 5 : 2,
                  ),
                ],
              ),
              child: Icon(
                widget.isListening ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            widget.isListening ? l10n.listening : l10n.tapMicToSpeak,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Submit button
        FilledButton(
          onPressed: widget.controller.text.trim().isNotEmpty ? widget.onSubmit : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(l10n.submit),
          ),
        ),
      ],
    );
  }
}
