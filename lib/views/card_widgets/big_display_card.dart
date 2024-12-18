import 'package:fam_assignment/models/card.dart';
import 'package:fam_assignment/models/cta.dart';
import 'package:fam_assignment/models/entity.dart';
import 'package:fam_assignment/models/formatted_text.dart';
import 'package:fam_assignment/services/storage_service.dart';
import 'package:fam_assignment/utils/color.dart';
import 'package:fam_assignment/view_model/card_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BigDisplayCard extends ConsumerStatefulWidget {
  final cardWidget card;
  final List<String> dismissedCardIds;
  final StorageService storageService;

  const BigDisplayCard({
    super.key,
    required this.card,
    required this.dismissedCardIds,
    required this.storageService,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BigDisplayCardState();
}

class _BigDisplayCardState extends ConsumerState<BigDisplayCard> {
  bool _isExpanded = false;
  double shifted = 120;

  @override
  Widget build(BuildContext context) {
    if (widget.dismissedCardIds.contains(widget.card.id.toString())) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 400,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          // Side menu for "Remind Later" and "Dismiss"
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isExpanded ? 0 : -shifted,
            top: 0,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              height: 420,
              width: shifted,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(cardViewModelProvider.notifier)
                              .remindLater(widget.card.id.toString());
                          setState(() {
                            widget.dismissedCardIds
                                .add(widget.card.id.toString());
                          });
                        },
                        child: Image.asset('assets/remind_later.png'),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          await ref
                              .read(cardViewModelProvider.notifier)
                              .dismissCard(widget.card.id.toString());
                          setState(() {
                            widget.dismissedCardIds
                                .add(widget.card.id.toString());
                          });
                        },
                        child: Image.asset('assets/dismiss.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Main card display
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: 0,
            bottom: 0,
            left: _isExpanded ? shifted : 0,
            child: GestureDetector(
              onLongPress: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              onTap: () {
                if (widget.card.url != null) {
                  ref
                      .read(cardViewModelProvider.notifier)
                      .handleDeepLink(widget.card.url);
                }
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.network(
                    widget.card.bgImage?.imageUrl ?? '',
                    fit: BoxFit.fitWidth,
                  ),
                  Positioned(
                    top: 150,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.card.formattedTitle != null)
                            _buildFormattedTitle(
                                widget.card.formattedTitle!, ref),
                          if (_isExpanded &&
                              widget.card.formattedDescription != null)
                            const SizedBox(height: 8),
                          if (_isExpanded &&
                              widget.card.formattedDescription != null)
                            _buildFormattedTitle(
                                widget.card.formattedDescription!, ref),
                          if (widget.card.cta != null)
                            const SizedBox(height: 30),
                          if (widget.card.cta != null)
                            _buildCTA(widget.card.cta![0]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedTitle(FormattedText formattedTitle, WidgetRef ref) {
    final parts = formattedTitle.text?.split('{}') ?? [];
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
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
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

  Widget _buildCTA(CTA cta) {
    return ElevatedButton(
      onPressed: () {
        if (cta.url != null) {
          ref.read(cardViewModelProvider.notifier).handleDeepLink(cta.url);
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: cta.textColor?.toColor() ?? Colors.white,
        backgroundColor: cta.bgColor?.toColor() ?? Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          cta.text!,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
