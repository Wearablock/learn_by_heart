import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_service.dart';
import '../models/memory_card.dart';

class CardRepository {
  static const _uuid = Uuid();

  Isar get _isar => DatabaseService.instance;

  // Create
  Future<MemoryCard> create({
    required String content,
    String? hint,
    String? categoryId,
  }) async {
    final card = MemoryCard.create(
      id: _uuid.v4(),
      content: content,
      hint: hint,
      categoryId: categoryId,
    );

    await _isar.writeTxn(() async {
      await _isar.memoryCards.put(card);
    });

    return card;
  }

  // Read
  Future<MemoryCard?> getById(String id) async {
    return await _isar.memoryCards.where().idEqualTo(id).findFirst();
  }

  Future<List<MemoryCard>> getAll() async {
    return await _isar.memoryCards.where().sortByCreatedAtDesc().findAll();
  }

  Future<List<MemoryCard>> getByCategory(String categoryId) async {
    return await _isar.memoryCards
        .where()
        .categoryIdEqualTo(categoryId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<List<MemoryCard>> getDueForReview() async {
    final now = DateTime.now();
    return await _isar.memoryCards
        .where()
        .filter()
        .nextReviewAtIsNull()
        .or()
        .nextReviewAtLessThan(now)
        .findAll();
  }

  Future<int> count() async {
    return await _isar.memoryCards.count();
  }

  // Update
  Future<MemoryCard> update(MemoryCard card) async {
    final updated = card.copyWith();
    await _isar.writeTxn(() async {
      await _isar.memoryCards.put(updated);
    });
    return updated;
  }

  Future<void> updateContent({
    required String id,
    required String content,
    String? hint,
  }) async {
    final card = await getById(id);
    if (card == null) return;

    final updated = card.copyWith(content: content, hint: hint);
    await _isar.writeTxn(() async {
      await _isar.memoryCards.put(updated);
    });
  }

  Future<void> updateStudyResult({
    required String id,
    required bool isCorrect,
    double? similarity,
  }) async {
    final card = await getById(id);
    if (card == null) return;

    final updated = card.copyWith(
      repetitionCount: card.repetitionCount + 1,
      lastStudiedAt: DateTime.now(),
      lastSimilarity: similarity,
      lastPassed: isCorrect,
    );

    await _isar.writeTxn(() async {
      await _isar.memoryCards.put(updated);
    });
  }

  // Delete
  Future<void> delete(String id) async {
    await _isar.writeTxn(() async {
      await _isar.memoryCards.where().idEqualTo(id).deleteFirst();
    });
  }

  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.memoryCards.clear();
    });
  }

  // Stream
  Stream<List<MemoryCard>> watchAll() {
    return _isar.memoryCards
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<int> watchCount() {
    return _isar.memoryCards.watchLazy(fireImmediately: true).asyncMap(
          (_) => _isar.memoryCards.count(),
        );
  }
}
