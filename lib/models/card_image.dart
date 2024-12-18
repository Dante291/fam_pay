class CardImage {
  final String? imageType;
  final String? imageUrl;

  CardImage({
    this.imageType,
    this.imageUrl,
  });

  factory CardImage.fromJson(Map<String, dynamic> json) {
    return CardImage(
      imageType: json['image_type'],
      imageUrl: json['image_url'],
    );
  }
}
