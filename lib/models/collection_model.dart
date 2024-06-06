class CollectionModel {
  final int id;
  final String name;
  final List<String> images;

  CollectionModel({
    required this.id,
    required this.name,
    required this.images,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      images: (json['images'] as List)
          .map((imageJson) => imageJson['image'] as String)
          .toList(),
    );
  }
}
