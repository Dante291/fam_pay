import 'card.dart';

enum DesignTypes {
  smallDisplayCard("HC1"),
  bigDisplayCard("HC3"),
  imageCard("HC5"),
  smallCardWithArrow("HC6"),
  dynamicWidthCard("HC9");

  final String code;
  const DesignTypes(this.code);

  factory DesignTypes.fromCode(String code) {
    return DesignTypes.values.firstWhere((e) => e.code == code,
        orElse: () => throw ArgumentError("Invalid DesignType code: $code"));
  }
}

class CardGroup {
  final DesignTypes? designType;
  final String? name;
  final List<cardWidget>? cards;
  final double? height; // Only used for HC9
  final bool? isScrollable; // Not used for HC9

  CardGroup({
    this.designType,
    this.name,
    this.cards,
    this.height,
    this.isScrollable,
  });

  factory CardGroup.fromJson(Map<String, dynamic> json) {
    final designType = DesignTypes.fromCode(json['design_type']);
    return CardGroup(
      designType: designType,
      name: json['name'],
      cards:
          (json['cards'] as List).map((e) => cardWidget.fromJson(e)).toList(),
      height: designType == DesignTypes.dynamicWidthCard
          ? json['height']?.toDouble()
          : null,
      isScrollable: designType != DesignTypes.dynamicWidthCard
          ? json['is_scrollable']
          : false,
    );
  }
}
