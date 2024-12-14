//download
import 'package:equatable/equatable.dart';
import 'package:yangi_tv_new/models/db/database_task.dart';

///download
///download
class DownloadState extends Equatable {
  final List<DatabaseTask> tasks;
  final DateTime time;

  DownloadState({
    required this.tasks,
    required this.time,
  });

  @override
  List<Object?> get props => [
        tasks,
        time,
      ];
}
