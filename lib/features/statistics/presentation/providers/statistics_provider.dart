import 'package:flutter/foundation.dart';
import '../../../card/data/models/memory_card.dart';
import '../../../card/data/repositories/card_repository.dart';
import '../../../study/data/repositories/study_repository.dart';
import '../../../study/data/models/study_session.dart';

class DailyStats {
  final DateTime date;
  final int studyCount;

  DailyStats({required this.date, required this.studyCount});
}

class CardStats {
  final String cardId;
  final String content;
  final int totalStudies;
  final int correctCount;
  final double accuracy;

  CardStats({
    required this.cardId,
    required this.content,
    required this.totalStudies,
    required this.correctCount,
    required this.accuracy,
  });
}

class StatisticsProvider extends ChangeNotifier {
  final CardRepository _cardRepository;
  final StudyRepository _studyRepository;

  bool _isLoading = true;
  int _totalStudyCount = 0;
  double _averageAccuracy = 0;
  List<DailyStats> _weeklyStats = [];
  List<DailyStats> _monthlyStats = [];
  List<CardStats> _cardStats = [];
  bool _isWeeklyView = true;

  StatisticsProvider({
    CardRepository? cardRepository,
    StudyRepository? studyRepository,
  })  : _cardRepository = cardRepository ?? CardRepository(),
        _studyRepository = studyRepository ?? StudyRepository() {
    loadStatistics();
  }

  // Getters
  bool get isLoading => _isLoading;
  int get totalStudyCount => _totalStudyCount;
  double get averageAccuracy => _averageAccuracy;
  List<DailyStats> get currentStats =>
      _isWeeklyView ? _weeklyStats : _monthlyStats;
  List<CardStats> get cardStats => _cardStats;
  bool get isWeeklyView => _isWeeklyView;

  void setWeeklyView(bool isWeekly) {
    if (_isWeeklyView != isWeekly) {
      _isWeeklyView = isWeekly;
      notifyListeners();
    }
  }

  Future<void> loadStatistics() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Overall stats
      _totalStudyCount = await _studyRepository.getTotalStudyCount();
      _averageAccuracy = await _studyRepository.getOverallAccuracy() * 100;

      // Session data for daily stats
      final sessions = await _studyRepository.getAllSessions();

      // Weekly stats (last 7 days)
      _weeklyStats = _calculateDailyStats(sessions, 7);

      // Monthly stats (last 30 days)
      _monthlyStats = _calculateDailyStats(sessions, 30);

      // Card stats
      final cards = await _cardRepository.getAll();
      _cardStats = await _calculateCardStats(cards);
    } catch (e) {
      debugPrint('Error loading statistics: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<DailyStats> _calculateDailyStats(
      List<StudySession> sessions, int days) {
    final today = DateTime.now();
    final stats = <DailyStats>[];

    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: i));

      final dayStudyCount = sessions.where((s) {
        final sessionDate = DateTime(
          s.startedAt.year,
          s.startedAt.month,
          s.startedAt.day,
        );
        return sessionDate.isAtSameMomentAs(date);
      }).fold(0, (sum, s) => sum + s.correctCount + s.wrongCount);

      stats.add(DailyStats(date: date, studyCount: dayStudyCount));
    }

    return stats;
  }

  Future<List<CardStats>> _calculateCardStats(List<MemoryCard> cards) async {
    final stats = <CardStats>[];

    for (final card in cards) {
      final records = await _studyRepository.getRecordsByCard(card.id);
      final correctCount = records.where((r) => r.isCorrect).length;
      final totalStudies = records.length;
      final accuracy =
          totalStudies > 0 ? (correctCount / totalStudies) * 100 : 0.0;

      stats.add(CardStats(
        cardId: card.id,
        content: card.content,
        totalStudies: totalStudies,
        correctCount: correctCount,
        accuracy: accuracy,
      ));
    }

    // Sort by total studies descending
    stats.sort((a, b) => b.totalStudies.compareTo(a.totalStudies));
    return stats;
  }

  Future<void> refresh() => loadStatistics();
}
