import 'package:fam_assignment/models/card_group.dart';
import 'package:fam_assignment/services/api_service.dart';
import 'package:fam_assignment/services/storage_service.dart';
import 'package:fam_assignment/views/card_group_widget.dart';
import 'package:fam_assignment/views/error_indicator.dart';
import 'package:fam_assignment/views/loading_indicator.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final StorageService storageService = StorageService();

  List<CardGroup> _cardGroups = [];
  List<String> _dismissedCardIds = [];
  bool _isLoading = true;
  bool _hasError = false;
  bool _isPreloading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadDismissedCards();
  }

  Future<void> _initializeData() async {
    try {
      final cardGroups = await apiService.fetchCardGroups();
      await _preloadImages(cardGroups);
      setState(() {
        _cardGroups = cardGroups;
        _isLoading = false;
        _isPreloading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _isPreloading = false;
      });
    }
  }

  Future<void> _preloadImages(List<CardGroup> cardGroups) async {
    final imageUrls = <String>[];

    for (var cardGroup in cardGroups) {
      // Collect backgroung image URLs from individual cards
      for (var card in cardGroup.cards!) {
        if (card.bgImage != null) {
          imageUrls.add(card.bgImage!.imageUrl!);
        }
      }
    }

    // Use Future.wait to preload images concurrently
    await Future.wait(imageUrls.map((imageUrl) {
      return precacheImage(
        NetworkImage(imageUrl),
        context,
        onError: (exception, stackTrace) {
          print('Error preloading image: $imageUrl');
        },
      );
    }));
  }

  Future<void> _loadDismissedCards() async {
    final dismissedCardIds = await storageService.getDismissedCardIds();
    setState(() {
      _dismissedCardIds = dismissedCardIds;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
      _isPreloading = true;
    });
    await _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isPreloading) {
      return const Scaffold(
        body: LoadingIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff7F6F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/fampay_logo.png',
          height: 40,
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _hasError
              ? const ErrorIndicator()
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 14),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView.builder(
                        itemCount: _cardGroups.length,
                        itemBuilder: (context, index) {
                          final cardGroup = _cardGroups[index];
                          return CardGroupWidget(
                            cardGroup: cardGroup,
                            dismissedCardIds: _dismissedCardIds,
                            storageService: storageService,
                          );
                        },
                      ),
                    ),
                  ),
                ),
    );
  }
}
