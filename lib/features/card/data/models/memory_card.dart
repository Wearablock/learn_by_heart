import 'package:isar/isar.dart';

part 'memory_card.g.dart';

@collection
class MemoryCard {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String content;

  String? hint;

  @Index()
  String? categoryId;

  late DateTime createdAt;

  late DateTime updatedAt;

  int repetitionCount = 0;

  int easeFactor = 3;

  DateTime? nextReviewAt;

  DateTime? lastStudiedAt;

  double? lastSimilarity;

  bool? lastPassed;

  MemoryCard();

  MemoryCard.create({
    required this.id,
    required this.content,
    this.hint,
    this.categoryId,
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  MemoryCard copyWith({
    String? content,
    String? hint,
    String? categoryId,
    int? repetitionCount,
    int? easeFactor,
    DateTime? nextReviewAt,
    DateTime? lastStudiedAt,
    double? lastSimilarity,
    bool? lastPassed,
  }) {
    final card = MemoryCard()
      ..isarId = isarId
      ..id = id
      ..content = content ?? this.content
      ..hint = hint ?? this.hint
      ..categoryId = categoryId ?? this.categoryId
      ..createdAt = createdAt
      ..updatedAt = DateTime.now()
      ..repetitionCount = repetitionCount ?? this.repetitionCount
      ..easeFactor = easeFactor ?? this.easeFactor
      ..nextReviewAt = nextReviewAt ?? this.nextReviewAt
      ..lastStudiedAt = lastStudiedAt ?? this.lastStudiedAt
      ..lastSimilarity = lastSimilarity ?? this.lastSimilarity
      ..lastPassed = lastPassed ?? this.lastPassed;
    return card;
  }
}
