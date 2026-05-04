import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'emergency_system.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, role TEXT)',
        );
        await db.execute(
          'CREATE TABLE requests(id INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT, userPhone TEXT, serviceType TEXT, time TEXT)',
        );
      },
    );
  }

  Future<void> registerUser(String name, String phone, String role) async {
    final db = await database;
    await db.insert('users', {'name': name, 'phone': phone, 'role': role});
  }

  Future<Map<String, dynamic>?> loginUser(String phone, String role) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(
      'users',
      where: 'phone = ? AND role = ?',
      whereArgs: [phone, role],
    );
    return res.isNotEmpty ? res.first : null;
  }

  Future<void> saveRequest(String name, String phone, String service) async {
    final db = await database;
    await db.insert('requests', {
      'userName': name,
      'userPhone': phone,
      'serviceType': service,
      'time': DateTime.now().toString(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllRequests() async {
    final db = await database;
    return await db.query('requests', orderBy: 'id DESC');
  }
}
