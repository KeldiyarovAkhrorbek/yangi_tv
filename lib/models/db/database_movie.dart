import 'dart:ui';

class DatabaseMovie {
  String name;
  String image;
  bool is_multi;

  DatabaseMovie({
    required this.name,
    required this.image,
    required this.is_multi,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatabaseMovie &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          image == other.image &&
          is_multi == other.is_multi;
}
