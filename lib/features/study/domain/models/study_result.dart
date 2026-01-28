class StudyResult {
  final String cardId;
  final bool isCorrect;
  final String userAnswer;
  final String correctAnswer;
  final int timeTakenMs;

  const StudyResult({
    required this.cardId,
    required this.isCorrect,
    required this.userAnswer,
    required this.correctAnswer,
    this.timeTakenMs = 0,
  });
}
