import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // ডেটাবেজ ফাইল ইনিশিয়ালাইজ করা
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'emergency_app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // টেবিল তৈরি করা: এখানে ইউজার এবং সার্ভিস রিকোয়েস্ট সেভ হবে
  Future _onCreate(Database db, int version) async {
    // ইউজার টেবিল (নাম, ফোন)
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT
      )
    ''');

    // সার্ভিস টেবিল (অ্যাম্বুলেন্স, পুলিশ ইত্যাদি যা ইউজার ক্লিক করবে)
    await db.execute('''
      CREATE TABLE services(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT,
        userPhone TEXT,
        serviceType TEXT,
        requestTime TEXT
      )
    ''');
  }

  // ইউজার রেজিস্ট্রেশন করার ফাংশন
  Future<int> registerUser(String name, String phone) async {
    Database db = await database;
    return await db.insert('users', {'name': name, 'phone': phone});
  }

  // ইউজার কোনো সার্ভিসে ক্লিক করলে সেটা সেভ করা (যাতে এডমিন দেখতে পায়)
  Future<int> requestService(String name, String phone, String type) async {
    Database db = await database;
    return await db.insert('services', {
      'userName': name,
      'userPhone': phone,
      'serviceType': type,
      'requestTime': DateTime.now().toString(),
    });
  }

  // এডমিনের জন্য সব ইউজারের সার্ভিস রিকোয়েস্ট লিস্ট দেখা
  Future<List<Map<String, dynamic>>> getAllRequests() async {
    Database db = await database;
    return await db.query('services', orderBy: 'id DESC');
  }

  // লগইন চেক করা (ফোন নম্বর দিয়ে)
  Future<Map<String, dynamic>?> loginUser(String phone) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
    );
    return results.isNotEmpty ? results.first : null;
  }
}
