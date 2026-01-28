import 'package:flutter/material.dart';
import '../../../../core/services/speech_service.dart';
import '../../../../core/utils/text_similarity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../card/data/models/memory_card.dart';
import '../../../card/data/repositories/card_repository.dart';
import '../../domain/models/study_result.dart';
import '../widgets/study_progress_bar.dart';
import '../widgets/speech_input_card.dart';
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
  final _speechService = SpeechService();
  final _answerController = TextEditingController();

  List<MemoryCard> _cards = [];
  final List<StudyResult> _results = [];

  int _currentIndex = 0;
  bool _isLoading = true;
  bool _showingFeedback = false;
  bool? _isCorrect;
  String? _error;
  double? _similarity;

  bool _isListening = false;
  String _recognizedText = '';
  bool _showTextField = false;

  DateTime? _cardStartTime;

  MemoryCard? get _currentCard =>
      _currentIndex < _cards.length ? _cards[_currentIndex] : null;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadCards();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _speechService.cancelListening();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    await _speechService.initialize();
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

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speechService.stopListening();
      setState(() => _isListening = false);
    } else {
      setState(() {
        _isListening = true;
        _recognizedText = '';
      });

      await _speechService.startListening(
        onResult: (text, isFinal) {
          setState(() {
            _recognizedText = text;
          });
          if (isFinal) {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          setState(() => _isListening = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          }
        },
        locale: _detectLocale(_currentCard?.content ?? ''),
      );
    }
  }

  String _detectLocale(String text) {
    // Simple locale detection based on character ranges
    if (RegExp(r'[\u3040-\u309F\u30A0-\u30FF]').hasMatch(text)) {
      return 'ja-JP'; // Japanese
    }
    if (RegExp(r'[\uAC00-\uD7AF]').hasMatch(text)) {
      return 'ko-KR'; // Korean
    }
    if (RegExp(r'[\u4E00-\u9FFF]').hasMatch(text)) {
      return 'zh-CN'; // Chinese
    }
    if (RegExp(r'[äöüßÄÖÜ]').hasMatch(text)) {
      return 'de-DE'; // German
    }
    if (RegExp(r'[éèêëàâùûôîïç]').hasMatch(text)) {
      return 'fr-FR'; // French
    }
    if (RegExp(r'[áéíóúñ¿¡]').hasMatch(text)) {
      return 'es-ES'; // Spanish
    }
    return 'en-US'; // Default to English
  }

  void _checkAnswer() {
    if (_currentCard == null) return;

    // Use recognized text or typed text
    final userAnswer = _recognizedText.isNotEmpty
        ? _recognizedText
        : _answerController.text.trim();
    final correctAnswer = _currentCard!.content.trim();

    // Calculate similarity
    final similarity = TextSimilarity.calculate(userAnswer, correctAnswer);
    final isCorrect = similarity >= 0.8; // 80% threshold

    final timeTaken = _cardStartTime != null
        ? DateTime.now().difference(_cardStartTime!).inMilliseconds
        : 0;

    _results.add(StudyResult(
      cardId: _currentCard!.id,
      isCorrect: isCorrect,
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
      similarity: similarity,
      timeTakenMs: timeTaken,
    ));

    setState(() {
      _showingFeedback = true;
      _isCorrect = isCorrect;
      _similarity = similarity;
    });
  }

  void _nextCard() {
    if (_currentIndex + 1 >= _cards.length) {
      _showResults();
    } else {
      setState(() {
        _currentIndex++;
        _showingFeedback = false;
        _isCorrect = null;
        _similarity = null;
        _recognizedText = '';
        _answerController.clear();
        _showTextField = false;
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
          cardIds: widget.cardIds,
        ),
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
              userAnswer: _recognizedText.isNotEmpty
                  ? _recognizedText
                  : _answerController.text.trim(),
              similarity: _similarity,
              onNext: _nextCard,
            )
          else
            SpeechInputCard(
              hint: _currentCard?.hint,
              recognizedText: _recognizedText,
              isListening: _isListening,
              controller: _answerController,
              onMicPressed: _toggleListening,
              onSubmit: _checkAnswer,
              showTextField: _showTextField,
              onToggleTextField: () {
                setState(() => _showTextField = !_showTextField);
              },
            ),
        ],
      ),
    );
  }
}
