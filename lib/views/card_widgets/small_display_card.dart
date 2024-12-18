import 'package:fam_assignment/models/card.dart';
import 'package:fam_assignment/models/entity.dart';
import 'package:fam_assignment/models/formatted_text.dart';
import 'package:fam_assignment/utils/color.dart';
import 'package:fam_assignment/view_model/card_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SmallDisplayCard extends ConsumerWidget {
  final cardWidget card;
  final bool isScrollable;

  const SmallDisplayCard({
    super.key,
    required this.card,
    required this.isScrollable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: card.bgColor?.toColor() ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          if (card.url != null) {
            ref.read(cardViewModelProvider.notifier).handleDeepLink(card.url);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenWidth * 0.02,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (card.icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Image.network(
                    card.icon!.imageUrl!,
                    width: 32,
                    height: 32,
                  ),
                ),
              isScrollable
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (card.formattedTitle != null)
                          _buildFormattedText(
                            card.formattedTitle!,
                            isDescription: false,
                            ref: ref,
                          ),
                        if (card.formattedDescription != null)
                          _buildFormattedText(
                            card.formattedDescription!,
                            isDescription: true,
                            ref: ref,
                          ),
                      ],
                    )
                  : Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (card.formattedTitle != null)
                            _buildFormattedText(
                              card.formattedTitle!,
                              isDescription: false,
                              ref: ref,
                            ),
                          if (card.formattedDescription != null)
                            _buildFormattedText(
                              card.formattedDescription!,
                              isDescription: true,
                              ref: ref,
                            ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormattedText(FormattedText formattedText,
      {required bool isDescription, required WidgetRef ref}) {
    final parts = formattedText.text?.split('{}') ?? [];
    final entities = formattedText.entities ?? [];

    return RichText(
      textAlign: TextAlign.left,
      overflow: TextOverflow.clip,
      maxLines: isDescription ? 1 : 1,
      text: TextSpan(
        children: _buildTextSpans(parts, entities, isDescription, ref),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(
    List<String> parts,
    List<Entity> entities,
    bool isDescription,
    WidgetRef ref,
  ) {
    List<TextSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(
              color: Colors.black,
              fontSize: isDescription ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
      if (i < entities.length) {
        final entity = entities[i];
        spans.add(
          TextSpan(
            text: entity.text,
            style: TextStyle(
              fontSize: isDescription ? 14 : 16,
              color: entity.color?.toColor(),
              fontWeight: entity.fontFamily == 'met_semi_bold'
                  ? FontWeight.bold
                  : FontWeight.normal,
              decoration: entity.url != null
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (entity.url != null) {
                  ref
                      .read(cardViewModelProvider.notifier)
                      .handleDeepLink(entity.url);
                }
              },
          ),
        );
      }
    }

    return spans;
  }
}
