import 'package:fam_assignment/models/card.dart';
import 'package:fam_assignment/view_model/card_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageCard extends ConsumerWidget {
  final cardWidget card;

  ImageCard({
    required this.card,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          if (card.url != null) {
            ref.read(cardViewModelProvider.notifier).handleDeepLink(card.url);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            card.bgImage!.imageUrl!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
