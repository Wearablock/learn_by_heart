import 'package:isar/isar.dart';

part 'study_record.g.dart';

@collection
class StudyRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index()
  late String cardId;

  @Index()
  late String sessionId;

  late bool isCorrect;

  late String userAnswer;

  int timeTakenMs = 0;

  late DateTime studiedAt;

  StudyRecord();

  StudyRecord.create({
    required this.id,
    required this.cardId,
    required this.sessionId,
    required this.isCorrect,
    required this.userAnswer,
    this.timeTakenMs = 0,
  }) {
    studiedAt = DateTime.now();
  }
}
