class Comment {
  int id;
  String name;
  String login;
  String photo;
  String? text;
  Reply? reply;
  String date;

  Comment({
    required this.id,
    required this.name,
    required this.login,
    required this.photo,
    required this.text,
    this.reply,
    required this.date,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      name: json['name'],
      login: json['login'],
      photo: json['photo'],
      text: json['text'],
      reply: json['reply'] != null ? Reply.fromJson(json['reply']) : null,
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'login': login,
      'photo': photo,
      'text': text,
      'reply': reply?.toJson(),
      'date': date,
    };
  }
}

class Reply {
  String? text;
  String? date;

  Reply({
    required this.text,
    required this.date,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      text: json['text'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'date': date,
    };
  }
}