class Gradient {
  final List<String>? colors;
  final double? angle;

  Gradient({
    this.colors,
    this.angle,
  });

  factory Gradient.fromJson(Map<String, dynamic> json) {
    return Gradient(
      colors: List<String>.from(json['colors']),
      angle: json['angle']?.toDouble(),
    );
  }
}
