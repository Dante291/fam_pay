import 'package:fam_assignment/models/entity.dart';

class FormattedText {
  final String? text;
  final List<Entity>? entities;

  FormattedText({
    this.text,
    this.entities,
  });

  factory FormattedText.fromJson(Map<String, dynamic> json) {
    return FormattedText(
      text: json['text'],
      entities:
          (json['entities'] as List).map((e) => Entity.fromJson(e)).toList(),
    );
  }
}
