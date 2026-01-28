import 'dart:math';
import 'package:flutter/material.dart';

class TextSimilarity {
  TextSimilarity._();

  static double calculate(String spoken, String target) {
    final spokenNormalized = _normalize(spoken);
    final targetNormalized = _normalize(target);

    if (spokenNormalized == targetNormalized) return 1.0;
    if (spokenNormalized.isEmpty) return 0.0;
    if (targetNormalized.isEmpty) return 0.0;

    // Word matching (70%)
    final spokenWords = spokenNormalized.split(' ').toSet();
    final targetWords = targetNormalized.split(' ').toSet();
    final matches = spokenWords.intersection(targetWords).length;
    final wordAccuracy = matches / targetWords.length;

    // Levenshtein distance based character matching (30%)
    final levenshteinScore = 1.0 -
        (_levenshteinDistance(spokenNormalized, targetNormalized) /
            max(targetNormalized.length, 1) *
            1.5);

    final result =
        (wordAccuracy * 0.7 + levenshteinScore.clamp(0.0, 1.0) * 0.3);
    return result.clamp(0.0, 1.0);
  }

  static String getFeedbackMessage(double accuracy) {
    if (accuracy >= 0.95) return 'Perfect!';
    if (accuracy >= 0.8) return 'Excellent!';
    if (accuracy >= 0.6) return 'Good!';
    if (accuracy >= 0.4) return 'Keep practicing!';
    return 'Try again.';
  }

  static Color getColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.6) return Colors.orange;
    return Colors.red;
  }

  static String toPercentString(double accuracy) {
    return '${(accuracy * 100).round()}%';
  }

  static String _normalize(String text) {
    return text
        .toLowerCase()
        // Remove punctuation but keep Unicode letters and numbers
        .replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<int> v0 = List<int>.generate(s2.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(s2.length + 1, 0);

    for (int i = 0; i < s1.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < s2.length; j++) {
        int cost = (s1[i] == s2[j]) ? 0 : 1;
        v1[j + 1] =
            [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost].reduce((a, b) => a < b ? a : b);
      }
      List<int> temp = v0;
      v0 = v1;
      v1 = temp;
    }

    return v0[s2.length];
  }
}
