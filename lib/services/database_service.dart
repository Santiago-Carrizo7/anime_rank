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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        date_added TEXT NOT NULL,
        sort_order INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE user_animes ADD COLUMN sort_order INTEGER');
    }
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
      orderBy: 'sort_order ASC, date_added DESC',
    );
    return maps.map((map) => TrackedAnime.fromMap(map)).toList();
  }

  Future<List<TrackedAnime>> getAllAnimes() async {
    final db = await database;
    final maps = await db.query(
      'user_animes',
      orderBy: 'sort_order ASC, date_added DESC',
    );
    return maps.map((map) => TrackedAnime.fromMap(map)).toList();
  }

  Future<void> updateSortOrders(List<TrackedAnime> animes) async {
    final db = await database;
    final batch = db.batch();
    for (var i = 0; i < animes.length; i++) {
      batch.update(
        'user_animes',
        {'sort_order': i},
        where: 'mal_id = ?',
        whereArgs: [animes[i].malId],
      );
    }
    await batch.commit(noResult: true);
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