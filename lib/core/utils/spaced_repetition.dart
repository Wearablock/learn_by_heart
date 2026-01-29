import 'dart:math';

class SpacedRepetition {
  SpacedRepetition._();

  /// Calculate next review date based on SM-2 algorithm (simplified)
  ///
  /// [repetitionCount]: How many times the card has been studied correctly in a row
  /// [easeFactor]: Difficulty factor (1-5, higher = easier)
  /// [isCorrect]: Whether the answer was correct
  /// [similarity]: How similar the answer was (0.0-1.0)
  static SpacedRepetitionResult calculate({
    required int repetitionCount,
    required int easeFactor,
    required bool isCorrect,
    double? similarity,
  }) {
    int newRepetitionCount;
    int newEaseFactor;
    Duration interval;

    if (isCorrect) {
      // Correct answer: increase interval
      newRepetitionCount = repetitionCount + 1;

      // Adjust ease factor based on similarity
      if (similarity != null && similarity >= 0.95) {
        newEaseFactor = min(easeFactor + 1, 5); // Perfect answer
      } else if (similarity != null && similarity < 0.85) {
        newEaseFactor = max(easeFactor - 1, 1); // Close but not great
      } else {
        newEaseFactor = easeFactor; // Good answer
      }

      // Calculate interval based on repetition count
      interval = _calculateInterval(newRepetitionCount, newEaseFactor);
    } else {
      // Wrong answer: reset repetition, decrease ease factor
      newRepetitionCount = 0;
      newEaseFactor = max(easeFactor - 1, 1);

      // Review again soon (10 minutes to 1 hour based on ease)
      interval = Duration(minutes: 10 * newEaseFactor);
    }

    return SpacedRepetitionResult(
      repetitionCount: newRepetitionCount,
      easeFactor: newEaseFactor,
      nextReviewAt: DateTime.now().add(interval),
    );
  }

  static Duration _calculateInterval(int repetitionCount, int easeFactor) {
    // Base intervals in days: 1, 3, 7, 14, 30, 60, 120...
    final baseIntervals = [1, 3, 7, 14, 30, 60, 120];

    final index = min(repetitionCount - 1, baseIntervals.length - 1);
    final baseDays = baseIntervals[max(0, index)];

    // Adjust by ease factor (1-5)
    // easeFactor 3 = normal, 5 = longer intervals, 1 = shorter intervals
    final adjustedDays = (baseDays * (easeFactor / 3.0)).round();

    return Duration(days: max(1, adjustedDays));
  }
}

class SpacedRepetitionResult {
  final int repetitionCount;
  final int easeFactor;
  final DateTime nextReviewAt;

  SpacedRepetitionResult({
    required this.repetitionCount,
    required this.easeFactor,
    required this.nextReviewAt,
  });
}
