import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'agendamentos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE agendamentos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cidade TEXT,
            lugar TEXT,
            dia TEXT,
            horario TEXT,
            servico TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertAgendamento(Map<String, String?> agendamento) async {
    final db = await database;
    await db.insert('agendamentos', agendamento);
  }

  Future<List<Map<String, dynamic>>> getAgendamentos() async {
    final db = await database;
    return await db.query('agendamentos');
  }

  Future<void> updateAgendamento(int id, Map<String, String?> agendamento) async {
    final db = await database;
    await db.update('agendamentos', agendamento, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAgendamento(int id) async {
    final db = await database;
    await db.delete('agendamentos', where: 'id = ?', whereArgs: [id]);
  }
  Future<void> insertLocalizacao(double latitude, double longitude) async {
    final db = await database;
    await db.insert(
      'localizacoes',
      {'latitude': latitude, 'longitude': longitude, 'timestamp': DateTime.now().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
