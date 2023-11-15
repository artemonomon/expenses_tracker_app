import 'package:expenses_tracker_app/database/database.dart';
import 'package:expenses_tracker_app/models/models.dart';
import 'package:sqflite/sqflite.dart';

class ExpensesRepository extends AbstractExpensesRepository {
  final ExpensesAppDb _expensesDb = ExpensesAppDb();

  @override
  Future<void> createDatabase(Database db) async {
    await _expensesDb.createDatabase(db);
  }

  @override
  Future<void> insertUser(User user) async {
    await _expensesDb.insertUser(user);
  }

  @override
  Future<void> insertPersonalAccount(PersonalAccount personalAccount) async {
    await _expensesDb.insertPersonalAccount(personalAccount);
  }

  @override
  Future<void> insertExpense(Expense expense) async {
    await _expensesDb.insertExpense(expense);
  }

  @override
  Future<void> insertIncome(Income income) async {
    await _expensesDb.insertIncome(income);
  }

  @override
  Future<List<Expense>> getExpenses() async {
    return await _expensesDb.getExpenses();
  }

  @override
  Future<List<Income>> getIncomes() async {
    return await _expensesDb.getIncomes();
  }

  @override
  Future<List<PersonalAccount>> getPersonalAccounts() async {
    return await _expensesDb.getPersonalAccounts();
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await _expensesDb.updateExpense(expense);
  }

  @override
  Future<void> updateIncome(Income income) async {
    await _expensesDb.updateIncome(income);
  }

  @override
  Future<void> updatePersonalAccount(PersonalAccount personalAccount) async {
    await _expensesDb.updatePersonalAccount(personalAccount);
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    await _expensesDb.deleteExpense(expenseId);
  }

  @override
  Future<void> deleteIncome(String incomeId) async {
    await _expensesDb.deleteIncome(incomeId);
  }

  @override
  Future<void> deletePersonalAccount(String personalAccountId) async {
    await _expensesDb.deletePersonalAccount(personalAccountId);
  }
}
