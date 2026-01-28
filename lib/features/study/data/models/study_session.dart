import 'package:isar/isar.dart';

part 'study_session.g.dart';

@collection
class StudySession {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late DateTime startedAt;

  DateTime? completedAt;

  int totalCards = 0;

  int correctCount = 0;

  int wrongCount = 0;

  List<String> cardIds = [];

  StudySession();

  StudySession.create({
    required this.id,
    required this.cardIds,
  }) {
    startedAt = DateTime.now();
    totalCards = cardIds.length;
  }

  @ignore
  double get accuracy {
    if (totalCards == 0) return 0;
    return correctCount / totalCards;
  }

  @ignore
  bool get isCompleted => completedAt != null;

  @ignore
  Duration? get duration {
    if (completedAt == null) return null;
    return completedAt!.difference(startedAt);
  }
}
