import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../card/data/models/memory_card.dart';
import '../../../card/data/repositories/card_repository.dart';
import '../../domain/models/study_result.dart';
import '../widgets/study_progress_bar.dart';
import '../widgets/study_card.dart';
import '../widgets/answer_feedback.dart';
import 'study_result_page.dart';

class StudyPage extends StatefulWidget {
  final List<String> cardIds;

  const StudyPage({super.key, required this.cardIds});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  final _repository = CardRepository();
  final _answerController = TextEditingController();

  List<MemoryCard> _cards = [];
  final List<StudyResult> _results = [];

  int _currentIndex = 0;
  bool _isLoading = true;
  bool _showingFeedback = false;
  bool? _isCorrect;
  String? _error;

  DateTime? _cardStartTime;

  MemoryCard? get _currentCard =>
      _currentIndex < _cards.length ? _cards[_currentIndex] : null;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cards = <MemoryCard>[];
      for (final id in widget.cardIds) {
        final card = await _repository.getById(id);
        if (card != null) {
          cards.add(card);
        }
      }

      // 셔플
      cards.shuffle();

      setState(() {
        _cards = cards;
        _isLoading = false;
        _cardStartTime = DateTime.now();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _checkAnswer() {
    if (_currentCard == null) return;

    final userAnswer = _answerController.text.trim();
    final correctAnswer = _currentCard!.content.trim();

    // 대소문자 무시 비교
    final isCorrect =
        userAnswer.toLowerCase() == correctAnswer.toLowerCase();

    final timeTaken = _cardStartTime != null
        ? DateTime.now().difference(_cardStartTime!).inMilliseconds
        : 0;

    _results.add(StudyResult(
      cardId: _currentCard!.id,
      isCorrect: isCorrect,
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
      timeTakenMs: timeTaken,
    ));

    setState(() {
      _showingFeedback = true;
      _isCorrect = isCorrect;
    });
  }

  void _nextCard() {
    if (_currentIndex + 1 >= _cards.length) {
      // 학습 완료
      _showResults();
    } else {
      setState(() {
        _currentIndex++;
        _showingFeedback = false;
        _isCorrect = null;
        _answerController.clear();
        _cardStartTime = DateTime.now();
      });
    }
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => StudyResultPage(
          results: _results,
          onRetry: () => _retryStudy(),
          onFinish: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _retryStudy() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => StudyPage(cardIds: widget.cardIds),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_results.isEmpty) return true;

    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.discardChanges),
        content: Text(l10n.studyExitConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.exit),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: _results.isEmpty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.studying),
        ),
        body: _buildBody(l10n),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadCards,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_cards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 64),
            const SizedBox(height: 16),
            Text(l10n.noCardsToStudy),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.backToHome),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StudyProgressBar(
            current: _currentIndex,
            total: _cards.length,
          ),
          const SizedBox(height: 32),
          if (_showingFeedback)
            AnswerFeedback(
              isCorrect: _isCorrect!,
              correctAnswer: _currentCard!.content,
              userAnswer: _answerController.text.trim(),
              onNext: _nextCard,
            )
          else
            StudyCard(
              hint: _currentCard?.hint,
              controller: _answerController,
              onSubmit: _checkAnswer,
            ),
        ],
      ),
    );
  }
}
