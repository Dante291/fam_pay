// ignore_for_file: camel_case_types

import 'package:fam_assignment/models/card_image.dart';
import 'package:fam_assignment/models/cta.dart';
import 'package:fam_assignment/models/formatted_text.dart';
import 'package:fam_assignment/models/gradient.dart';

class cardWidget {
  final String? id;
  final String? title;
  final String? name;
  final FormattedText? formattedTitle;
  final String? description;
  final FormattedText? formattedDescription;
  final CardImage? icon;
  final String? url;
  final CardImage? bgImage;
  final String? bgColor;
  final Gradient? bgGradient;
  final List<CTA>? cta;

  cardWidget({
    this.id,
    this.name,
    this.title,
    this.formattedTitle,
    this.description,
    this.formattedDescription,
    this.icon,
    this.url,
    this.bgImage,
    this.bgColor,
    this.bgGradient,
    this.cta,
  });

  factory cardWidget.fromJson(Map<String, dynamic> json) {
    return cardWidget(
      title: json['title'],
      name: json['name'],
      formattedTitle: json['formatted_title'] != null
          ? FormattedText.fromJson(json['formatted_title'])
          : null,
      description: json['description'],
      formattedDescription: json['formatted_description'] != null
          ? FormattedText.fromJson(json['formatted_description'])
          : null,
      icon: json['icon'] != null ? CardImage.fromJson(json['icon']) : null,
      url: json['url'],
      bgImage: json['bg_image'] != null
          ? CardImage.fromJson(json['bg_image'])
          : null,
      bgColor: json['bg_color'],
      bgGradient: json['bg_gradient'] != null
          ? Gradient.fromJson(json['bg_gradient'])
          : null,
      cta: json['cta'] != null
          ? (json['cta'] as List).map((e) => CTA.fromJson(e)).toList()
          : null,
    );
  }
}
