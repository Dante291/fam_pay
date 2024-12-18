import 'package:fam_assignment/models/card.dart';
import 'package:fam_assignment/models/entity.dart';
import 'package:fam_assignment/models/formatted_text.dart';
import 'package:fam_assignment/utils/color.dart';
import 'package:fam_assignment/view_model/card_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Required for gesture recognition
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SmallCardWithArrow extends ConsumerWidget {
  final cardWidget card;

  SmallCardWithArrow({
    required this.card,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (card.icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Image.network(
                    card.icon!.imageUrl!,
                    width: 32,
                    height: 32,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _buildFormattedTitle(card.formattedTitle, ref),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormattedTitle(FormattedText? formattedTitle, WidgetRef ref) {
    if (formattedTitle == null || formattedTitle.text == null) {
      return const Text(
        '',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final parts = formattedTitle.text!.split('{}');
    final entities = formattedTitle.entities ?? [];

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        children: _buildTextSpans(parts, entities, ref),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(
      List<String> parts, List<Entity> entities, WidgetRef ref) {
    List<TextSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(
          TextSpan(
            text: parts[i],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        spans.add(const TextSpan(text: '\n'));
      }
      if (i < entities.length) {
        final entity = entities[i];
        spans.add(
          TextSpan(
            text: entity.text,
            style: TextStyle(
              fontSize: entity.fontsize ?? 16,
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
