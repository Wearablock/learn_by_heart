class StudyResult {
  final String cardId;
  final bool isCorrect;
  final String userAnswer;
  final String correctAnswer;
  final double similarity;
  final int timeTakenMs;

  const StudyResult({
    required this.cardId,
    required this.isCorrect,
    required this.userAnswer,
    required this.correctAnswer,
    required this.similarity,
    this.timeTakenMs = 0,
  });
}
