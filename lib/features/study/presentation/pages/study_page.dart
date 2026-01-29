import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/services/speech_service.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/utils/text_similarity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../card/data/models/memory_card.dart';
import '../../../card/data/repositories/card_repository.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../data/repositories/study_repository.dart';
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
  final _studyRepository = StudyRepository();
  final _speechService = SpeechService();
  final _answerController = TextEditingController();

  List<MemoryCard> _cards = [];
  final List<StudyResult> _results = [];
  String? _sessionId;

  int _currentIndex = 0;
  bool _isLoading = true;
  bool _showingFeedback = false;
  bool? _isCorrect;
  String? _error;
  double? _similarity;

  bool _isListening = false;
  DateTime? _cardStartTime;
  InterstitialAd? _interstitialAd;

  MemoryCard? get _currentCard =>
      _currentIndex < _cards.length ? _cards[_currentIndex] : null;

  @override
  void initState() {
    super.initState();
    _answerController.addListener(_onTextChanged);
    _initSpeech();
    _loadCards();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _answerController.removeListener(_onTextChanged);
    _answerController.dispose();
    _speechService.cancelListening();
    _interstitialAd?.dispose();
    super.dispose();
  }

  Future<void> _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: AdService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint('Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: ${error.message}');
          _interstitialAd = null;
        },
      ),
    );
  }

  void _onTextChanged() {
    // Trigger rebuild to update submit button state
    setState(() {});
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

      // Create study session
      if (cards.isNotEmpty) {
        final session = await _studyRepository.createSession(
          cardIds: cards.map((c) => c.id).toList(),
        );
        _sessionId = session.id;
      }

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
      });

      await _speechService.startListening(
        onResult: (text, isFinal) {
          // Update the text controller with recognized text
          _answerController.text = text;
          _answerController.selection = TextSelection.fromPosition(
            TextPosition(offset: _answerController.text.length),
          );
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

  Future<void> _stopListening() async {
    if (_isListening) {
      await _speechService.stopListening();
      setState(() => _isListening = false);
    }
  }

  String _detectLocale(String text) {
    if (RegExp(r'[\u3040-\u309F\u30A0-\u30FF]').hasMatch(text)) {
      return 'ja-JP';
    }
    if (RegExp(r'[\uAC00-\uD7AF]').hasMatch(text)) {
      return 'ko-KR';
    }
    if (RegExp(r'[\u4E00-\u9FFF]').hasMatch(text)) {
      return 'zh-CN';
    }
    if (RegExp(r'[äöüßÄÖÜ]').hasMatch(text)) {
      return 'de-DE';
    }
    if (RegExp(r'[éèêëàâùûôîïç]').hasMatch(text)) {
      return 'fr-FR';
    }
    if (RegExp(r'[áéíóúñ¿¡]').hasMatch(text)) {
      return 'es-ES';
    }
    return 'en-US';
  }

  Future<void> _checkAnswer() async {
    if (_currentCard == null) return;

    final userAnswer = _answerController.text.trim();
    final correctAnswer = _currentCard!.content.trim();

    final similarity = TextSimilarity.calculate(userAnswer, correctAnswer);
    final passThreshold = context.read<SettingsProvider>().passThreshold;
    final isCorrect = similarity >= passThreshold;

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

    // Update card study result
    await _repository.updateStudyResult(
      id: _currentCard!.id,
      isCorrect: isCorrect,
      similarity: similarity,
    );

    // Create study record
    if (_sessionId != null) {
      await _studyRepository.createRecord(
        cardId: _currentCard!.id,
        sessionId: _sessionId!,
        isCorrect: isCorrect,
        userAnswer: userAnswer,
        timeTakenMs: timeTaken,
      );
    }

    setState(() {
      _showingFeedback = true;
      _isCorrect = isCorrect;
      _similarity = similarity;
    });
  }

  Future<void> _nextCard() async {
    if (_currentIndex + 1 >= _cards.length) {
      await _showResults();
    } else {
      setState(() {
        _currentIndex++;
        _showingFeedback = false;
        _isCorrect = null;
        _similarity = null;
        _answerController.clear();
        _cardStartTime = DateTime.now();
      });
    }
  }

  Future<void> _showResults() async {
    // Complete the study session
    if (_sessionId != null) {
      final correctCount = _results.where((r) => r.isCorrect).length;
      final wrongCount = _results.where((r) => !r.isCorrect).length;

      await _studyRepository.completeSession(
        sessionId: _sessionId!,
        correctCount: correctCount,
        wrongCount: wrongCount,
      );
    }

    if (!mounted) return;

    // Show interstitial ad before navigating to results
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _navigateToResults();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          debugPrint('Interstitial ad failed to show: ${error.message}');
          _navigateToResults();
        },
      );
      await _interstitialAd!.show();
    } else {
      _navigateToResults();
    }
  }

  void _navigateToResults() {
    if (!mounted) return;

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
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (_cards.isEmpty) {
      final theme = Theme.of(context);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyStateImage(
              assetPath: AppImages.emptyStudy,
              fallbackIcon: Icons.inbox_outlined,
              size: 100,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
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
              similarity: _similarity,
              onNext: _nextCard,
            )
          else
            SpeechInputCard(
              hint: _currentCard?.hint,
              isListening: _isListening,
              controller: _answerController,
              onMicPressed: _toggleListening,
              onSubmit: _checkAnswer,
              onTypingStarted: _stopListening,
            ),
        ],
      ),
    );
  }
}
