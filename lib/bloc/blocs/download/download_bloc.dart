import 'dart:convert';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yangi_tv_new/bloc/blocs/download/download_event.dart';
import 'package:yangi_tv_new/bloc/blocs/download/download_state.dart';
import 'package:yangi_tv_new/bloc/repos/mainrepository.dart';
import 'package:yangi_tv_new/models/db/database_task.dart';

///download
///download
///download
class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final MainRepository _mainRepository;
  List<DatabaseTask> all_tasks = [];
  DateTime time = DateTime.now();

  DownloadBloc(this._mainRepository)
      : super(DownloadState(
          tasks: [],
          time: DateTime.now(),
        )) {
    on<AddDownloadEvent>((event, emit) async {
      var taskIndex = -1;
      taskIndex = all_tasks.indexWhere((element) => element.url == event.url);
      if (taskIndex != -1) return;

      int fileSize = await _mainRepository.getFileSize(event.url);

      Map<String, dynamic> meta_data_map = {
        'movie_name': event.movie_name,
        'name': event.name,
        'image': event.image,
        'season_name': event.seasonName,
        'size': fileSize,
        'tariff': event.tariff,
        'is_multi': event.is_multi,
      };

      final task = DownloadTask(
        url: event.url,
        filename: event.url.substring(event.url.lastIndexOf("/") + 1),
        updates: Updates.statusAndProgress,
        requiresWiFi: false,
        retries: 10,
        displayName: event.displayName,
        baseDirectory: Platform.isAndroid
            ? BaseDirectory.temporary
            : BaseDirectory.applicationLibrary,
        allowPause: true,
        metaData: jsonEncode(meta_data_map),
      );

      var result = await FileDownloader().enqueue(task);
      if (result)
        all_tasks.add(DatabaseTask(
          taskId: task.taskId,
          movieName: meta_data_map['movie_name'],
          name: meta_data_map['name'],
          displayName: task.displayName,
          url: task.url,
          size: 0,
          tariff: event.tariff,
          image: event.image,
          networkSpeed: 0,
          progress: 0,
          status: TaskStatus.enqueued,
          remainingTime: 0,
          is_multi: event.is_multi,
          seasonName: event.seasonName,
          path: '',
        ));
    });

    on<DownloadTaskStatusUpdateEvent>((event, emit) async {
      var index = -1;
      index = all_tasks
          .indexWhere((element) => element.taskId == event.update.task.taskId);
      if (index == -1) {
        return;
      }
      all_tasks[index].status = event.update.status;
      all_tasks[index].path = await event.update.task.filePath();
      if (event.update.status == TaskStatus.canceled ||
          event.update.status == TaskStatus.notFound ||
          event.update.status == TaskStatus.failed) {
        await FileDownloader().cancelTaskWithId(event.update.task.taskId);
        await FileDownloader()
            .database
            .deleteRecordWithId(event.update.task.taskId);
        all_tasks.removeWhere(
            (element) => element.taskId == event.update.task.taskId);
      }

      emit(DownloadState(
        tasks: all_tasks,
        time: DateTime.now(),
      ));
    });

    on<DownloadTaskProgressUpdateEvent>((event, emit) async {
      var index = -1;
      index = all_tasks
          .indexWhere((element) => element.taskId == event.update.task.taskId);
      if (index == -1) {
        return;
      }
      if (event.update.progress > 0)
        all_tasks[index].progress = event.update.progress;
      if (event.update.expectedFileSize > 0)
        all_tasks[index].size = event.update.expectedFileSize;
      if (event.update.networkSpeed > 0)
        all_tasks[index].networkSpeed = event.update.networkSpeed;
      all_tasks[index].remainingTime = event.update.timeRemaining.inSeconds;

      emit(DownloadState(
        tasks: all_tasks,
        time: DateTime.now(),
      ));
    });

    on<UpdateDownloadsEvent>((event, emit) async {
      emit(DownloadState(
        tasks: all_tasks,
        time: DateTime.now(),
      ));
    });

    on<SetTasksEvent>((event, emit) async {
      all_tasks = event.tasks;
      emit(DownloadState(
        tasks: all_tasks,
        time: DateTime.now(),
      ));
    });

    on<ResumeTaskEvent>((event, emit) async {
      var task = await FileDownloader().taskForId(event.taskId);
      if (task != null) {
        await FileDownloader().resume(DownloadTask(
          url: task.url,
          metaData: task.metaData,
          headers: task.headers,
          allowPause: task.allowPause,
          baseDirectory: task.baseDirectory,
          creationTime: task.creationTime,
          directory: task.directory,
          displayName: task.displayName,
          filename: task.filename,
          group: task.group,
          httpRequestMethod: task.httpRequestMethod,
          post: task.post,
          priority: task.priority,
          taskId: task.taskId,
          retries: task.retries,
          requiresWiFi: task.requiresWiFi,
          updates: task.updates,
        ));
      }
    });

    on<PauseTaskEvent>((event, emit) async {
      var task = await FileDownloader().taskForId(event.taskId);
      if (task != null) {
        await FileDownloader().pause(DownloadTask(
          url: task.url,
          metaData: task.metaData,
          headers: task.headers,
          allowPause: task.allowPause,
          baseDirectory: task.baseDirectory,
          creationTime: task.creationTime,
          directory: task.directory,
          displayName: task.displayName,
          filename: task.filename,
          group: task.group,
          httpRequestMethod: task.httpRequestMethod,
          post: task.post,
          priority: task.priority,
          taskId: task.taskId,
          retries: task.retries,
          requiresWiFi: task.requiresWiFi,
          updates: task.updates,
        ));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      final Directory directory = await getApplicationSupportDirectory();
      var taskRecord =
          await FileDownloader().database.recordForId(event.taskId);
      if (taskRecord == null) return;
      if (taskRecord.status == TaskStatus.complete) {
        all_tasks.removeWhere((element) => element.taskId == event.taskId);
        await FileDownloader().database.deleteRecordWithId(event.taskId);
        File file = File(
          directory.path +
              directory.path +
              '/' +
              taskRecord.task.url
                  .substring(taskRecord.task.url.lastIndexOf("/") + 1),
        );
        var exists = await file.exists();
        if (exists) await file.delete();
      } else {
        var result = await FileDownloader().cancelTaskWithId(event.taskId);
        await FileDownloader().database.deleteRecordWithId(event.taskId);
        if (result) {
          all_tasks.removeWhere((element) => element.taskId == event.taskId);
        }
      }

      emit(DownloadState(tasks: all_tasks, time: DateTime.now()));
    });
  }
}
