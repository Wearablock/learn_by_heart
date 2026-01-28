import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_service.dart';
import '../models/study_session.dart';
import '../models/study_record.dart';

class StudyRepository {
  static const _uuid = Uuid();

  Isar get _isar => DatabaseService.instance;

  // Session - Create
  Future<StudySession> createSession({
    required List<String> cardIds,
  }) async {
    final session = StudySession.create(
      id: _uuid.v4(),
      cardIds: cardIds,
    );

    await _isar.writeTxn(() async {
      await _isar.studySessions.put(session);
    });

    return session;
  }

  // Session - Read
  Future<StudySession?> getSessionById(String id) async {
    return await _isar.studySessions.where().idEqualTo(id).findFirst();
  }

  Future<List<StudySession>> getAllSessions() async {
    return await _isar.studySessions
        .where()
        .sortByStartedAtDesc()
        .findAll();
  }

  Future<List<StudySession>> getRecentSessions({int limit = 10}) async {
    return await _isar.studySessions
        .where()
        .sortByStartedAtDesc()
        .limit(limit)
        .findAll();
  }

  // Session - Update
  Future<void> completeSession({
    required String sessionId,
    required int correctCount,
    required int wrongCount,
  }) async {
    final session = await getSessionById(sessionId);
    if (session == null) return;

    session
      ..completedAt = DateTime.now()
      ..correctCount = correctCount
      ..wrongCount = wrongCount;

    await _isar.writeTxn(() async {
      await _isar.studySessions.put(session);
    });
  }

  // Record - Create
  Future<StudyRecord> createRecord({
    required String cardId,
    required String sessionId,
    required bool isCorrect,
    required String userAnswer,
    int timeTakenMs = 0,
  }) async {
    final record = StudyRecord.create(
      id: _uuid.v4(),
      cardId: cardId,
      sessionId: sessionId,
      isCorrect: isCorrect,
      userAnswer: userAnswer,
      timeTakenMs: timeTakenMs,
    );

    await _isar.writeTxn(() async {
      await _isar.studyRecords.put(record);
    });

    return record;
  }

  // Record - Read
  Future<List<StudyRecord>> getRecordsBySession(String sessionId) async {
    return await _isar.studyRecords
        .where()
        .sessionIdEqualTo(sessionId)
        .findAll();
  }

  Future<List<StudyRecord>> getRecordsByCard(String cardId) async {
    return await _isar.studyRecords
        .where()
        .cardIdEqualTo(cardId)
        .sortByStudiedAtDesc()
        .findAll();
  }

  // Statistics
  Future<int> getTotalStudyCount() async {
    return await _isar.studyRecords.count();
  }

  Future<int> getCorrectCount() async {
    return await _isar.studyRecords
        .where()
        .filter()
        .isCorrectEqualTo(true)
        .count();
  }

  Future<double> getOverallAccuracy() async {
    final total = await getTotalStudyCount();
    if (total == 0) return 0;
    final correct = await getCorrectCount();
    return correct / total;
  }

  // Delete
  Future<void> deleteSession(String id) async {
    await _isar.writeTxn(() async {
      // Delete related records first
      await _isar.studyRecords.where().sessionIdEqualTo(id).deleteAll();
      // Delete session
      await _isar.studySessions.where().idEqualTo(id).deleteFirst();
    });
  }

  Future<void> deleteAllSessions() async {
    await _isar.writeTxn(() async {
      await _isar.studyRecords.clear();
      await _isar.studySessions.clear();
    });
  }
}
