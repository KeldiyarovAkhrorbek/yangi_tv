import 'package:sqflite/sqflite.dart';
import 'package:yangi_tv_new/database/database_service.dart';

class StoryDB {
  final tableName = 'story';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER NOT NULL
        );""");
  }

  Future<int> create({required int id}) async {
    final database = await DatabaseService().database;
    return await database.insert(
      tableName,
      {"id": id},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<int>> fetchAllWatchedStories() async {
    final database = await DatabaseService().database;
    final stories = await database.rawQuery("""
    SELECT * from ${tableName}""");
    return stories.map((e) => int.parse(e["id"].toString())).toList();
  }
}
