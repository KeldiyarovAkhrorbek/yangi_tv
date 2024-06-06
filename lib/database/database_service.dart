import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yangi_tv_new/database/episode_db.dart';
import 'package:yangi_tv_new/database/movie_db.dart';
import 'package:yangi_tv_new/database/story_db.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'yangi.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 3,
      onCreate: create,
      onUpgrade: upgrade,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async {
    await StoryDB().createTable(database);
    await MovieDB().createTable(database);
    await EpisodeDB().createTable(database);
  }

  Future<void> upgrade(
      Database database, int oldVersion, int newVersion) async {
    await StoryDB().createTable(database);
    await MovieDB().createTable(database);
    await EpisodeDB().createTable(database);
  }
}
