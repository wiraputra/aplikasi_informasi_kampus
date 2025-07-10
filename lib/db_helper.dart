import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'saran_model.dart';

class DatabaseHelper {
  // Singleton pattern untuk memastikan hanya ada satu instance database
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const String _dbName = 'kampus.db';
  static const String _tableName = 'saran';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Membuat tabel saat database pertama kali dibuat
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        email TEXT NOT NULL,
        pesan TEXT NOT NULL
      )
    ''');
  }

  // Method untuk memasukkan data saran ke database
  Future<void> insertSaran(Saran saran) async {
    final db = await database;
    await db.insert(
      _tableName,
      saran.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method untuk mengambil semua data saran dari database
  Future<List<Saran>> getAllSaran() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'id DESC', // Mengurutkan berdasarkan ID terbaru dulu
    );

    return List.generate(maps.length, (i) {
      return Saran(
        id: maps[i]['id'],
        nama: maps[i]['nama'],
        email: maps[i]['email'],
        pesan: maps[i]['pesan'],
      );
    });
  }

  // Method untuk menghapus saran berdasarkan ID.
  Future<void> deleteSaran(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // PENAMBAHAN BARU: Method untuk memperbarui saran yang ada.
  Future<void> updateSaran(Saran saran) async {
    final db = await database;
    await db.update(
      _tableName,
      saran.toMap(),
      where: 'id = ?',
      whereArgs: [saran.id],
    );
  }
}