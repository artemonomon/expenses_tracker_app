import 'package:expenses_tracker_app/models/models.dart';

class User {
  int id;
  String name;
  List<PersonalAccount> personalAccounts;

  User({
    required this.id,
    required this.name,
    required this.personalAccounts,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
