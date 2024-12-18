class Entity {
  final String? text;
  final String? color;
  final String? fontStyle;
  final String? url;
  final double? fontsize;
  final String? fontFamily;

  Entity(
      {this.text,
      this.color,
      this.fontStyle,
      this.url,
      this.fontsize,
      this.fontFamily});

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      text: json['text'],
      color: json['color'],
      fontStyle: json['font_style'],
      url: json['url'],
      fontsize: json['font_size'] != null
          ? (json['font_size'] as num).toDouble()
          : null,
      fontFamily: json['font_family'],
    );
  }
}
