class Season {
  final int id;
  final String name;
  final List<Episode> episodes;

  Season({
    required this.id,
    required this.name,
    required this.episodes,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    List<dynamic> episodesList = json['series'];
    List<Episode> episodes = episodesList
        .map((episodeJson) => Episode.fromJson(episodeJson))
        .toList();

    return Season(
      id: json['id'],
      name: json['name'],
      episodes: episodes,
    );
  }
}

class Episode {
  final int id;
  final String name;
  final List<String>? file;
  final List<String>? p2p_embed;

  Episode({
    required this.id,
    required this.name,
    required this.file,
    required this.p2p_embed,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      name: json['name'],
      file:
          json["fileA"] == "" ? null : List<String>.from(json["fileA"] ?? null),
      p2p_embed: json["p2p_embed"] == ""
          ? null
          : List<String>.from(json["p2p_embed"] ?? null),
    );
  }
}
