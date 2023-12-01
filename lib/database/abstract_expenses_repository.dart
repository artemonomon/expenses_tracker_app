import 'package:expenses_tracker_app/models/models.dart';
import 'package:sqflite/sqflite.dart';

abstract class AbstractExpensesRepository {
  Future<void> createDatabase(Database db);
  Future<void> insertUser(User user);
  Future<void> insertPersonalAccount(PersonalAccount personalAccount);
  Future<void> insertExpense(Expense expense);
  Future<void> insertIncome(Income income);
  Future<List<Expense>> getExpenses();
  Future<List<Income>> getIncomes();
  Future<List<PersonalAccount>> getPersonalAccounts();
  Future<void> updateExpense(Expense expense);
  Future<void> updateIncome(Income income);
  Future<void> updatePersonalAccount(PersonalAccount personalAccount);
  Future<void> deleteExpense(int expenseId);
  Future<void> deleteIncome(int incomeId);
  Future<void> deletePersonalAccount(int personalAccountId);
}
