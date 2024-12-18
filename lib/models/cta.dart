class CTA {
  final String? text;
  final String? bgColor;
  final String? url;
  final String? textColor;

  CTA({
    this.text,
    this.bgColor,
    this.url,
    this.textColor,
  });

  factory CTA.fromJson(Map<String, dynamic> json) {
    return CTA(
      text: json['text'],
      bgColor: json['bg_color'],
      url: json['url'],
      textColor: json['text_color'],
    );
  }
}
