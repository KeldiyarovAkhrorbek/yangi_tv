class BannerModel {
  int id;
  String name;
  String image;
  int? contentId;
  String? url;

  BannerModel({
    required this.id,
    required this.name,
    required this.image,
    required this.contentId,
    this.url,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      contentId: json['content_id'],
      url: json['url'], // Assuming 'url' can be null
    );
  }
}
