import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;
  bool get isAvailable => _isInitialized;

  /// Debug logging helper
  void _log(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _isInitialized = await _speech.initialize(
        onError: _onError,
        onStatus: _onStatus,
        debugLogging: false,
      );
      return _isInitialized;
    } catch (e) {
      _log('Speech initialization failed: $e');
      return false;
    }
  }

  Future<void> startListening({
    required Function(String text, bool isFinal) onResult,
    Function(String)? onError,
    String locale = 'en-US',
  }) async {
    if (!_isInitialized) {
      final success = await initialize();
      if (!success) {
        onError?.call('Speech recognition not available');
        return;
      }
    }

    if (_isListening) return;

    _isListening = true;

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      localeId: locale,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  Future<void> stopListening() async {
    if (!_isListening) return;
    await _speech.stop();
    _isListening = false;
  }

  Future<void> cancelListening() async {
    await _speech.cancel();
    _isListening = false;
  }

  Future<List<LocaleName>> getAvailableLocales() async {
    if (!_isInitialized) await initialize();
    return _speech.locales();
  }

  void _onError(SpeechRecognitionError error) {
    _log('Speech error: ${error.errorMsg}');
    _isListening = false;
  }

  void _onStatus(String status) {
    _log('Speech status: $status');
    if (status == 'done' || status == 'notListening') {
      _isListening = false;
    }
  }
}
