import 'package:background_downloader/background_downloader.dart';

String getTaskStatusText(TaskStatus status) {
  switch (status) {
    case TaskStatus.complete:
      {
        return "Yuklandi";
      }
    case TaskStatus.enqueued:
      {
        return "Kutilmoqda";
      }
    case TaskStatus.canceled:
      {
        return "Bekor qilindi";
      }
    case TaskStatus.failed:
      {
        return "Bekor qilindi";
      }
    case TaskStatus.notFound:
      {
        return "Fayl topilmadi";
      }
    case TaskStatus.paused:
      {
        return "Pauza qilindi";
      }
    case TaskStatus.running:
      {
        return "Yuklanmoqda";
      }
    default:
      {
        return "Kutilmoqda";
      }
  }
}
