import 'dart:convert';

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
    String path = join(await getDatabasesPath(), 'orders.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        batchNumber INTEGER,
        data TEXT
      )
    ''');
  }

  Future<void> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    await db.insert(
      'orders',
      order,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query('orders');
  }

  Future<bool> tagNumberExists(String tagNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      columns: ['data'],
    );

    for (var map in maps) {
      List<dynamic> dataList = jsonDecode(map['data']);
      for (var data in dataList) {
        if (data['tagNumber'] == tagNumber) {
          return true;
        }
      }
    }

    return false;
  }
}
