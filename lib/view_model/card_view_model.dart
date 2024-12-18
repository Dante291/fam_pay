import 'package:fam_assignment/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class CardViewModel extends StateNotifier<List<String>> {
  final StorageService storageService;

  CardViewModel({required this.storageService}) : super([]);

  // Permanently dismiss a card
  Future<void> dismissCard(String cardId) async {
    await storageService.addDismissedCardId(cardId);
    state = [...state, cardId];
  }

  // Temporarily dismiss a card
  void temporarilyDismissCard(String cardId) {
    storageService.temporarilyDismissCard(cardId);
    state = [...state, cardId];
  }

  // Remind later action (temporary dismissal)
  void remindLater(String cardId) {
    temporarilyDismissCard(cardId);
  }

  Future<void> handleDeepLink(String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url)); // Open the URL if it's valid
    } else {
      // Optionally, show an error if the URL can't be launched
      print('Could not launch URL: $url');
    }
  }
}

final cardViewModelProvider =
    StateNotifierProvider<CardViewModel, List<String>>(
  (ref) => CardViewModel(storageService: ref.read(storageServiceProvider)),
);
