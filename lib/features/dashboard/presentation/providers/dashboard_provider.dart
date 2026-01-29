import 'package:flutter/foundation.dart';
import '../../../card/data/models/memory_card.dart';
import '../../../card/data/repositories/card_repository.dart';
import '../../../study/data/repositories/study_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final CardRepository _cardRepository;
  final StudyRepository _studyRepository;

  bool _isLoading = true;
  MemoryCard? _recentCard;
  int _todayStudyCount = 0;
  double _todayAccuracy = 0;
  int _streak = 0;
  int _dueCardsCount = 0;
  List<String> _dueCardIds = [];

  DashboardProvider({
    CardRepository? cardRepository,
    StudyRepository? studyRepository,
  })  : _cardRepository = cardRepository ?? CardRepository(),
        _studyRepository = studyRepository ?? StudyRepository() {
    loadDashboardData();
  }

  // Getters
  bool get isLoading => _isLoading;
  MemoryCard? get recentCard => _recentCard;
  int get todayStudyCount => _todayStudyCount;
  double get todayAccuracy => _todayAccuracy;
  int get streak => _streak;
  int get dueCardsCount => _dueCardsCount;
  List<String> get dueCardIds => _dueCardIds;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load recent card (most recently studied)
      final cards = await _cardRepository.getAll();
      final studiedCards =
          cards.where((c) => c.lastStudiedAt != null).toList();
      studiedCards.sort(
          (a, b) => b.lastStudiedAt!.compareTo(a.lastStudiedAt!));
      _recentCard = studiedCards.isNotEmpty ? studiedCards.first : null;

      // Load due cards
      final dueCards = await _cardRepository.getDueForReview();
      _dueCardsCount = dueCards.length;
      _dueCardIds = dueCards.map((c) => c.id).toList();

      // Load today's study stats
      final sessions = await _studyRepository.getRecentSessions(limit: 100);
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);

      final todaySessions = sessions
          .where((s) => s.startedAt.isAfter(todayStart))
          .toList();

      int totalCorrect = 0;
      int totalWrong = 0;
      for (final session in todaySessions) {
        totalCorrect += session.correctCount;
        totalWrong += session.wrongCount;
      }

      _todayStudyCount = totalCorrect + totalWrong;
      _todayAccuracy = _todayStudyCount > 0
          ? (totalCorrect / _todayStudyCount) * 100
          : 0;

      // Calculate streak
      _streak = await _calculateStreak(sessions);
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> _calculateStreak(List sessions) async {
    if (sessions.isEmpty) return 0;

    final today = DateTime.now();
    int streak = 0;
    DateTime checkDate = DateTime(today.year, today.month, today.day);

    // Check if studied today
    final studiedToday = sessions.any((s) {
      final sessionDate = DateTime(
        s.startedAt.year,
        s.startedAt.month,
        s.startedAt.day,
      );
      return sessionDate.isAtSameMomentAs(checkDate);
    });

    if (!studiedToday) {
      // Check yesterday
      checkDate = checkDate.subtract(const Duration(days: 1));
      final studiedYesterday = sessions.any((s) {
        final sessionDate = DateTime(
          s.startedAt.year,
          s.startedAt.month,
          s.startedAt.day,
        );
        return sessionDate.isAtSameMomentAs(checkDate);
      });
      if (!studiedYesterday) return 0;
    }

    // Count consecutive days
    while (true) {
      final hasStudy = sessions.any((s) {
        final sessionDate = DateTime(
          s.startedAt.year,
          s.startedAt.month,
          s.startedAt.day,
        );
        return sessionDate.isAtSameMomentAs(checkDate);
      });

      if (hasStudy) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Future<void> refresh() => loadDashboardData();
}
