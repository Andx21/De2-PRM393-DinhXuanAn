import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final dbPath = await getDatabasesPath();

    final path = join(
      dbPath,
      'expense_database.db',
    );

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            amount REAL NOT NULL
          )
        ''');

        final samples = [
          {
            'name': 'Ăn uống',
            'category': 'Sinh hoạt',
            'date': '2026-10-29T00:00:00.000',
            'amount': 150000.0,
          },
          {
            'name': 'Di chuyển',
            'category': 'Đi lại',
            'date': '2026-10-28T00:00:00.000',
            'amount': 50000.0,
          },
          {
            'name': 'Mua sách',
            'category': 'Học tập',
            'date': '2026-10-27T00:00:00.000',
            'amount': 200000.0,
          },
          {
            'name': 'Mua sắm',
            'category': 'Sinh hoạt',
            'date': '2026-10-25T00:00:00.000',
            'amount': 1500000.0,
          },
          {
            'name': 'Khám bệnh',
            'category': 'Sức khỏe',
            'date': '2026-10-22T00:00:00.000',
            'amount': 3550000.0,
          },
        ];

        for (final sample in samples) {
          await db.insert('expenses', sample);
        }
      },
    );

    return _database!;
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await database;

    return await db.query(
      'expenses',
      orderBy: 'date DESC',
    );
  }

  Future<int> updateExpense(Map<String, dynamic> data) async {
    final db = await database;

    return await db.update(
      'expenses',
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }
}