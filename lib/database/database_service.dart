import 'package:expenses_tracker_app/database/expenses_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<String> get _dbPath async {
    const name = 'expenses_tracker.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initDatabase() async {
    final path = await _dbPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      singleInstance: true,
    );
    return database;
  }

  Future<void> _createDatabase(Database db, int version) async =>
      await ExpensesAppDb().createDatabase(db);
}
