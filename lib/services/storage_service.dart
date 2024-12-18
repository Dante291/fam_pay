import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _dismissedCardsKey = 'dismissed_cards';
  final List<String> _tempDismissedCards = [];

  Future<List<String>> getDismissedCardIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_dismissedCardsKey) ?? [];
  }

  Future<void> addDismissedCardId(String cardId) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedCardIds = await getDismissedCardIds();
    if (!dismissedCardIds.contains(cardId)) {
      dismissedCardIds.add(cardId);
      await prefs.setStringList(_dismissedCardsKey, dismissedCardIds);
    }
  }

  Future<void> removeDismissedCardId(String cardId) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedCardIds = await getDismissedCardIds();
    if (dismissedCardIds.contains(cardId)) {
      dismissedCardIds.remove(cardId);
      await prefs.setStringList(_dismissedCardsKey, dismissedCardIds);
    }
  }

  void temporarilyDismissCard(String cardId) {
    if (!_tempDismissedCards.contains(cardId)) {
      _tempDismissedCards.add(cardId);
    }
  }

  bool isCardTemporarilyDismissed(String cardId) {
    return _tempDismissedCards.contains(cardId);
  }

  void clearTemporaryDismissals() {
    _tempDismissedCards.clear();
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
