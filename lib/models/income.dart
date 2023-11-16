import 'package:expenses_tracker_app/models/models.dart';

class Income {
  int? id;
  String title;
  double amount;
  PersonalAccount personalAccount;
  DateTime date;
  String category;

  Income({
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
