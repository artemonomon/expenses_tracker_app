class PersonalAccount {
  int id;
  String name;
  double balance;

  PersonalAccount({
    required this.id,
    required this.name,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }
}
