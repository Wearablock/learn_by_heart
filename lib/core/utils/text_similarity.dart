import 'dart:math';
import 'package:flutter/material.dart';

/// Answer matching utility for memorization practice
/// Uses a hybrid approach combining multiple similarity algorithms
class AnswerMatcher {
  AnswerMatcher._();

  /// Calculate similarity score between user input and target answer
  /// Returns a value between 0.0 (no match) and 1.0 (perfect match)
  ///
  /// Algorithm weights:
  /// - 55% Token overlap (word matching)
  /// - 25% Edit distance (Levenshtein-based)
  /// - 20% Sequence similarity (Jaro-Winkler inspired)
  static double score(String userInput, String expected) {
    final inputNormalized = _normalizeText(userInput);
    final expectedNormalized = _normalizeText(expected);

    if (inputNormalized == expectedNormalized) return 1.0;
    if (inputNormalized.isEmpty || expectedNormalized.isEmpty) return 0.0;

    // Token overlap score (55%)
    final tokenScore = _calculateTokenOverlap(inputNormalized, expectedNormalized);

    // Edit distance score (25%)
    final editScore = _calculateEditDistanceScore(inputNormalized, expectedNormalized);

    // Sequence similarity score (20%)
    final sequenceScore = _calculateSequenceSimilarity(inputNormalized, expectedNormalized);

    final combined = (tokenScore * 0.55) + (editScore * 0.25) + (sequenceScore * 0.20);
    return combined.clamp(0.0, 1.0);
  }

  /// Get localized feedback based on accuracy
  static String feedbackFor(double accuracy) {
    if (accuracy >= 0.95) return 'Perfect!';
    if (accuracy >= 0.85) return 'Excellent!';
    if (accuracy >= 0.70) return 'Great!';
    if (accuracy >= 0.50) return 'Good effort!';
    if (accuracy >= 0.30) return 'Keep practicing!';
    return 'Try again.';
  }

  /// Get color indicator for accuracy level
  static Color colorFor(double accuracy) {
    if (accuracy >= 0.80) return const Color(0xFF4CAF50);  // Green
    if (accuracy >= 0.50) return const Color(0xFFFF9800);  // Orange
    return const Color(0xFFE53935);  // Red
  }

  /// Format accuracy as percentage string
  static String formatPercent(double accuracy) {
    return '${(accuracy * 100).round()}%';
  }

  /// Token overlap calculation
  static double _calculateTokenOverlap(String input, String expected) {
    final inputTokens = input.split(' ').where((t) => t.isNotEmpty).toSet();
    final expectedTokens = expected.split(' ').where((t) => t.isNotEmpty).toSet();

    if (expectedTokens.isEmpty) return 0.0;

    final matchCount = inputTokens.intersection(expectedTokens).length;
    return matchCount / expectedTokens.length;
  }

  /// Edit distance score (inverse normalized Levenshtein)
  static double _calculateEditDistanceScore(String input, String expected) {
    final distance = _computeLevenshtein(input, expected);
    final maxLen = max(input.length, expected.length);
    if (maxLen == 0) return 1.0;

    // Normalize and invert (closer = higher score)
    final normalized = distance / maxLen;
    return (1.0 - normalized * 1.2).clamp(0.0, 1.0);
  }

  /// Sequence similarity (prefix/suffix matching bonus)
  static double _calculateSequenceSimilarity(String input, String expected) {
    final shorter = input.length <= expected.length ? input : expected;
    final longer = input.length > expected.length ? input : expected;

    if (shorter.isEmpty) return 0.0;

    // Common prefix length
    int prefixLen = 0;
    final maxPrefix = min(shorter.length, 4);
    for (int i = 0; i < maxPrefix; i++) {
      if (shorter[i] == longer[i]) {
        prefixLen++;
      } else {
        break;
      }
    }

    // Common suffix length
    int suffixLen = 0;
    final maxSuffix = min(shorter.length - prefixLen, 4);
    for (int i = 0; i < maxSuffix; i++) {
      if (shorter[shorter.length - 1 - i] == longer[longer.length - 1 - i]) {
        suffixLen++;
      } else {
        break;
      }
    }

    // Combined sequence bonus
    final sequenceBonus = (prefixLen + suffixLen) / (maxPrefix + maxSuffix);
    return sequenceBonus.clamp(0.0, 1.0);
  }

  /// Normalize text for comparison
  static String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Compute Levenshtein edit distance
  static int _computeLevenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    List<int> prevRow = List<int>.generate(b.length + 1, (i) => i);
    List<int> currRow = List<int>.filled(b.length + 1, 0);

    for (int i = 0; i < a.length; i++) {
      currRow[0] = i + 1;
      for (int j = 0; j < b.length; j++) {
        final cost = (a[i] == b[j]) ? 0 : 1;
        currRow[j + 1] = [
          currRow[j] + 1,
          prevRow[j + 1] + 1,
          prevRow[j] + cost,
        ].reduce(min);
      }
      final temp = prevRow;
      prevRow = currRow;
      currRow = temp;
    }

    return prevRow[b.length];
  }
}

/// Legacy alias for backward compatibility
@Deprecated('Use AnswerMatcher instead')
typedef TextSimilarity = AnswerMatcher;
