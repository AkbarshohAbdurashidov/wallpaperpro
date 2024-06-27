class Images {
  final int imageId;
  final String imageAlt;
  final String imagePotraitPath;
  final String photographer;

  Images({
    required this.photographer,
    required this.imageId,
    required this.imageAlt,
    required this.imagePotraitPath,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        imageId: json['id'] as int,
        imageAlt: json['alt'] as String,
        photographer: json['photographer'] as String,
        imagePotraitPath: json['src']['portrait'] as String,
      );

  Images.emptyConstructor({
    this.imageId = 0,
    this.imageAlt = "",
    this.imagePotraitPath = "",
    this.photographer = "",
  });
}
