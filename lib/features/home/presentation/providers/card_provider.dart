import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../card/data/models/memory_card.dart';
import '../../../card/data/repositories/card_repository.dart';

class CardProvider extends ChangeNotifier {
  final CardRepository _repository;

  List<MemoryCard> _cards = [];
  bool _isLoading = true;
  String? _error;
  StreamSubscription? _subscription;

  CardProvider({CardRepository? repository})
      : _repository = repository ?? CardRepository() {
    _subscribeToCards();
  }

  // Getters
  List<MemoryCard> get cards => _cards;
  bool get isLoading => _isLoading;
  bool get isEmpty => _cards.isEmpty;
  String? get error => _error;
  int get cardCount => _cards.length;

  void _subscribeToCards() {
    _subscription = _repository.watchAll().listen(
      (cards) {
        _cards = cards;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> loadCards() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cards = await _repository.getAll();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<MemoryCard> addCard(String content, {String? hint}) async {
    final card = await _repository.create(
      content: content,
      hint: hint,
    );
    return card;
  }

  Future<void> updateCard({
    required String id,
    required String content,
    String? hint,
  }) async {
    await _repository.updateContent(
      id: id,
      content: content,
      hint: hint,
    );
  }

  Future<void> deleteCard(String id) async {
    await _repository.delete(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
