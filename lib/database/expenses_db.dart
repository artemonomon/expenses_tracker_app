import 'package:expenses_tracker_app/database/database.dart';
import 'package:expenses_tracker_app/models/models.dart';
import 'package:sqflite/sqflite.dart';

class ExpensesAppDb {
  final expensesTableName = 'expenses';
  final incomeTableName = 'income';
  final personalAccountsTableName = 'personal_accounts';
  final usersTableName = 'users';
  final categoriesTableName = 'categories';

  Future<void> createDatabase(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $expensesTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        date TEXT,
        personal_account_id INTEGER,
        category TEXT,
        FOREIGN KEY(personal_account_id) REFERENCES $personalAccountsTableName(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $incomeTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        date TEXT,
        personal_account_id INTEGER,
        category TEXT,
        FOREIGN KEY(personal_account_id) REFERENCES $personalAccountsTableName(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $personalAccountsTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        user_id INTEGER,
        balance REAL,
        currency TEXT,
        category TEXT,
        FOREIGN KEY(user_id) REFERENCES $usersTableName(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $usersTableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
  }

  Future<void> insertUser(User user) async {
    final db = await DatabaseService().database;
    await db.insert(usersTableName, user.toMap());
  }

  Future<void> insertPersonalAccount(PersonalAccount personalAccount) async {
    final db = await DatabaseService().database;
    await db.insert(personalAccountsTableName, personalAccount.toMap());
  }

  Future<void> insertExpense(Expense expense) async {
    final db = await DatabaseService().database;
    await db.insert(expensesTableName, expense.toMap());
  }

  Future<void> insertIncome(Income income) async {
    final db = await DatabaseService().database;
    await db.insert(incomeTableName, income.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query(expensesTableName);
    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        personalAccount: PersonalAccount(
          id: maps[i]['personal_account_id'],
          name: 'Savings', // Replace with the actual account name
          balance: 0.0, // Replace with the actual balance
        ),
        date: DateTime.parse(maps[i]['date']),
        category: maps[i]['category'],
      );
    });
  }

  Future<List<Income>> getIncomes() async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query(incomeTableName);
    return List.generate(maps.length, (i) {
      return Income(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        personalAccount: PersonalAccount(
          id: maps[i]['personal_account_id'],
          name: 'Savings', // Replace with the actual account name
          balance: 0.0, // Replace with the actual balance
        ),
        date: DateTime.parse(maps[i]['date']),
        category: maps[i]['category'],
      );
    });
  }

  Future<List<PersonalAccount>> getPersonalAccounts() async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps =
        await db.query(personalAccountsTableName);
    return List.generate(maps.length, (i) {
      return PersonalAccount(
        id: maps[i]['id'],
        name: maps[i]['name'],
        balance: maps[i]['balance'],
        currency: maps[i]['currency'],
        category: maps[i]['category'],
      );
    });
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await DatabaseService().database;
    await db.update(
      expensesTableName,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> updateIncome(Income income) async {
    final db = await DatabaseService().database;
    await db.update(
      incomeTableName,
      income.toMap(),
      where: 'id = ?',
      whereArgs: [income.id],
    );
  }

  Future<void> updatePersonalAccount(PersonalAccount personalAccount) async {
    final db = await DatabaseService().database;
    await db.update(
      personalAccountsTableName,
      personalAccount.toMap(),
      where: 'id = ?',
      whereArgs: [personalAccount.id],
    );
  }

  Future<void> deleteExpense(String expenseId) async {
    final db = await DatabaseService().database;
    await db.delete(
      expensesTableName,
      where: 'id = ?',
      whereArgs: [expenseId],
    );
  }

  Future<void> deleteIncome(String incomeId) async {
    final db = await DatabaseService().database;
    await db.delete(
      incomeTableName,
      where: 'id = ?',
      whereArgs: [incomeId],
    );
  }

  Future<void> deletePersonalAccount(int personalAccountId) async {
    final db = await DatabaseService().database;
    await db.delete(
      personalAccountsTableName,
      where: 'id = ?',
      whereArgs: [personalAccountId],
    );
  }
}
