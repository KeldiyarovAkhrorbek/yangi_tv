import 'package:background_downloader/background_downloader.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:yangi_tv_new/models/db/database_task.dart';

///download
///download
///download
@immutable
abstract class DownloadEvent extends Equatable {
  const DownloadEvent();
}

class SetTasksEvent extends DownloadEvent {
  List<DatabaseTask> tasks;

  SetTasksEvent(this.tasks);

  @override
  List<Object?> get props => [
        tasks,
      ];
}

class DownloadTaskStatusUpdateEvent extends DownloadEvent {
  final TaskStatusUpdate update;

  DownloadTaskStatusUpdateEvent(this.update);

  @override
  List<Object?> get props => [
        update,
      ];
}

class DownloadTaskProgressUpdateEvent extends DownloadEvent {
  final TaskProgressUpdate update;

  DownloadTaskProgressUpdateEvent(this.update);

  @override
  List<Object?> get props => [
        update,
      ];
}

class LoadAllDownloadTasksEvent extends DownloadEvent {
  @override
  List<Object?> get props => [];
}

class UpdateDownloadsEvent extends DownloadEvent {
  @override
  List<Object?> get props => [];
}

class ResumeTaskEvent extends DownloadEvent {
  final String taskId;

  ResumeTaskEvent(this.taskId);

  @override
  List<Object?> get props => [];
}

class PauseTaskEvent extends DownloadEvent {
  final String taskId;

  PauseTaskEvent(this.taskId);

  @override
  List<Object?> get props => [];
}

class DeleteTaskEvent extends DownloadEvent {
  final String taskId;

  DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [];
}

class AddDownloadEvent extends LoadAllDownloadTasksEvent {
  final String movie_name;
  final String name;
  final String displayName;
  final String image;
  final String url;
  final String? seasonName;
  final bool is_multi;
  final String tariff;

  AddDownloadEvent({
    required this.movie_name,
    required this.name,
    required this.displayName,
    required this.image,
    required this.url,
    required this.seasonName,
    required this.is_multi,
    required this.tariff,
  });

  @override
  List<Object?> get props => [];
}
