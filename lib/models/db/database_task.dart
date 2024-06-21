import 'package:background_downloader/background_downloader.dart';

class DatabaseTask {
  String taskId;
  String movieName;
  String name;
  String displayName;
  String image;
  String url;
  String tariff;
  double networkSpeed;
  double progress;
  int size;
  TaskStatus status;
  int remainingTime;
  String? seasonName;
  bool is_multi;
  String path;

  DatabaseTask({
    required this.taskId,
    required this.movieName,
    required this.name,
    required this.displayName,
    required this.url,
    required this.image,
    required this.status,
    required this.tariff,
    required this.size,
    required this.networkSpeed,
    required this.progress,
    required this.remainingTime,
    required this.is_multi,
    required this.path,
    this.seasonName,
  });
}
