import 'package:expenses_tracker_app/models/models.dart';

class Expense {
  int? id;
  String title;
  double amount;
  PersonalAccount personalAccount;
  String category;
  DateTime date;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.personalAccount,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'personal_account_id': personalAccount.id,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
}
