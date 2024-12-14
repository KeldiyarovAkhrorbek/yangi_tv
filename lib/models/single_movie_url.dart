class SingleMovieUrl {
  List<String>? resolution360A;
  List<String>? resolution480A;
  List<String>? resolution720A;
  List<String>? resolution1080A;
  List<String>? resolution2160A;
  List<String>? p2p_embed;

  SingleMovieUrl({
    List<String>? a360A,
    List<String>? a480A,
    List<String>? a720A,
    List<String>? a1080A,
    List<String>? a2160A,
    List<String>? sp2p_embed,
  })  : resolution360A = a360A,
        resolution480A = a480A,
        resolution720A = a720A,
        resolution1080A = a1080A,
        p2p_embed = sp2p_embed;

  factory SingleMovieUrl.fromJson(Map<String, dynamic> json) {
    return SingleMovieUrl(
      a360A:
          json["360A"] == "" ? null : List<String>.from(json["360A"] ?? null),
      a480A:
          json["480A"] == "" ? null : List<String>.from(json["480A"] ?? null),
      a720A:
          json["720A"] == "" ? null : List<String>.from(json["720A"] ?? null),
      a1080A:
          json["1080A"] == "" ? null : List<String>.from(json["1080A"] ?? null),
      a2160A:
          json["2160A"] == "" ? null : List<String>.from(json["2160A"] ?? null),
      sp2p_embed: json["p2p_embed"] == ""
          ? null
          : List<String>.from(json["p2p_embed"] ?? null),
    );
  }
}
