import 'package:sqflite/sqflite.dart';
import 'package:yangi_tv_new/database/database_service.dart';

class EpisodeDB {
  final tableName = 'episode_watch';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY,
        time INTEGER NOT NULL
        );""");
  }

  Future<int> create({required int id, required int time}) async {
    final database = await DatabaseService().database;
    return await database.insert(
      tableName,
      {
        "id": id,
        "time": time,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> fetchWatchedEpisodeTime(int id) async {
    final database = await DatabaseService().database;
    var movies =
        await database.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (movies.isEmpty) return 0;
    return movies.first['time'] as int;
  }
}
