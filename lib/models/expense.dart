import 'package:expenses_tracker_app/models/models.dart';

class Expense {
  String id;
  String title;
  double amount;
  PersonalAccount personalAccount;
  DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.personalAccount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'personal_account_id': personalAccount.id,
      'date': date.toIso8601String(),
    };
  }
}
