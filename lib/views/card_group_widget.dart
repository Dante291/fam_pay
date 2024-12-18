import 'package:fam_assignment/models/card.dart';
import 'package:fam_assignment/models/card_group.dart';
import 'package:fam_assignment/services/storage_service.dart';
import 'package:fam_assignment/views/card_widgets/big_display_card.dart';
import 'package:fam_assignment/views/card_widgets/dynamic_width_card.dart';
import 'package:fam_assignment/views/card_widgets/image_card.dart';
import 'package:fam_assignment/views/card_widgets/small_card_with_arrow.dart';
import 'package:fam_assignment/views/card_widgets/small_display_card.dart';
import 'package:flutter/material.dart';

class CardGroupWidget extends StatefulWidget {
  final CardGroup cardGroup;
  final List<String> dismissedCardIds;
  final StorageService storageService;

  const CardGroupWidget({
    super.key,
    required this.cardGroup,
    required this.dismissedCardIds,
    required this.storageService,
  });

  @override
  State<CardGroupWidget> createState() => _CardGroupWidgetState();
}

class _CardGroupWidgetState extends State<CardGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          if (widget.cardGroup.cards!.length > 1 &&
              (widget.cardGroup.designType!.code == 'HC9' ||
                  widget.cardGroup.isScrollable == true))
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: widget.cardGroup.height ?? 65.0,
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.cardGroup.cards!.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _buildCard(widget.cardGroup.cards![index]),
                ),
              ),
            )
          // Non-scrollable view with equal width when isScrollable is false
          else if (widget.cardGroup.cards!.length > 1 &&
              widget.cardGroup.isScrollable == false)
            Row(
              children: widget.cardGroup.cards!
                  .map((card) => Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _buildCard(card),
                        ),
                      ))
                  .toList(),
            )
          // Single card scenario
          else if (widget.cardGroup.cards!.length == 1)
            _buildCard(widget.cardGroup.cards![0])
        ],
      ),
    );
  }

  Widget _buildCard(cardWidget card) {
    switch (widget.cardGroup.designType!.code) {
      case 'HC1':
        return SmallDisplayCard(
          card: card,
          isScrollable: widget.cardGroup.isScrollable!,
        );
      case 'HC3':
        return BigDisplayCard(
            card: card,
            dismissedCardIds: widget.dismissedCardIds,
            storageService: widget.storageService);
      case 'HC5':
        return ImageCard(card: card);
      case 'HC6':
        return SmallCardWithArrow(card: card);
      case 'HC9':
        return DynamicWidthCard(card: card);
      default:
        return const SizedBox.shrink();
    }
  }
}
