import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/anime_status.dart';
import '../models/tracked_anime.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'anime_rank.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_animes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mal_id INTEGER UNIQUE NOT NULL,
        title TEXT NOT NULL,
        image_url TEXT,
        episodes INTEGER,
        status TEXT NOT NULL,
        date_added TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertAnime(TrackedAnime anime) async {
    final db = await database;
    return await db.insert(
      'user_animes',
      anime.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateStatus(int malId, AnimeStatus newStatus) async {
    final db = await database;
    return await db.update(
      'user_animes',
      {'status': newStatus.dbValue},
      where: 'mal_id = ?',
      whereArgs: [malId],
    );
  }

  Future<int> deleteAnime(int malId) async {
    final db = await database;
    return await db.delete(
      'user_animes',
      where: 'mal_id = ?',
      whereArgs: [malId],
    );
  }

  Future<List<TrackedAnime>> getAnimesByStatus(AnimeStatus status) async {
    final db = await database;
    final maps = await db.query(
      'user_animes',
      where: 'status = ?',
      whereArgs: [status.dbValue],
      orderBy: 'date_added DESC',
    );
    return maps.map((map) => TrackedAnime.fromMap(map)).toList();
  }

  Future<List<TrackedAnime>> getAllAnimes() async {
    final db = await database;
    final maps = await db.query(
      'user_animes',
      orderBy: 'date_added DESC',
    );
    return maps.map((map) => TrackedAnime.fromMap(map)).toList();
  }

  Future<TrackedAnime?> getAnimeByMalId(int malId) async {
    final db = await database;
    final maps = await db.query(
      'user_animes',
      where: 'mal_id = ?',
      whereArgs: [malId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return TrackedAnime.fromMap(maps.first);
  }

  Future<bool> isAnimeTracked(int malId) async {
    final anime = await getAnimeByMalId(malId);
    return anime != null;
  }
}