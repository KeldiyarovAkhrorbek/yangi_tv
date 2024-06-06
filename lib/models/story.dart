class Story {
  final int? id;
  final String? name;
  final int? contentId;
  final String? image;
  final String? video;
  bool watched;

  Story({
    required this.id,
    required this.name,
    required this.contentId,
    required this.image,
    required this.video,
    required this.watched,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      name: json['name'],
      contentId: json['content_id'],
      image: json['image'],
      video: json['video'],
      watched: false,
    );
  }
}
