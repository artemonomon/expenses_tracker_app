import 'package:expenses_tracker_app/models/models.dart';

class Income {
  String id;
  String name;
  double amount;
  PersonalAccount personalAccount;
  DateTime date;

  Income({
    required this.id,
    required this.name,
    required this.amount,
    required this.personalAccount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'personal_account_id': personalAccount.id,
      'date': date.toIso8601String(),
    };
  }
}
