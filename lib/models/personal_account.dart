import 'package:flutter/material.dart';

class PersonalAccount {
  int? id;
  String? name;
  double? balance;
  String? currency = 'UAH';
  String? category;
  String? icon;

  PersonalAccount({
    this.id,
    this.name,
    this.balance,
    this.currency,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'currency': currency,
      'category': category,
    };
  }

  PersonalAccount copyWith({
    int? id,
    String? name,
    double? balance,
    String? currency,
    String? category,
    String? icon,
  }) {
    return PersonalAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalAccount &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          balance == other.balance &&
          currency == other.currency &&
          category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      balance.hashCode ^
      currency.hashCode ^
      category.hashCode;

  double? convertToUAH() {
    // Assuming that the exchange rates are available
    // You might want to fetch the latest exchange rates from an API
    const usdToUAHRate = 36.0; // Replace with the actual exchange rate
    const eurToUAHRate = 39.0; // Replace with the actual exchange rate

    switch (currency) {
      case 'UAH':
        return balance;
      case 'USD':
        return balance! * usdToUAHRate;
      case 'EUR':
        return balance! * eurToUAHRate;
      default:
        throw Exception('Unsupported currency: $currency');
    }
  }
}

// Helper method to get the icon for a specific account category
IconData? getIconForCategory(String? category) {
  switch (category) {
    case "Готівка":
      return Icons.attach_money; // Use the icon for cash
    case "Кредитна карта":
      return Icons.credit_card; // Use the icon for credit card
    case "Дебетова карта":
      return Icons.payment; // Use the icon for debit card
  }
  return null;
}

Color getIconColorForCategory(String? category) {
  switch (category) {
    case "Готівка":
      return Colors.yellow; // Yellow color for cash
    case "Кредитна карта":
      return Colors.red; // Red color for credit card
    case "Дебетова карта":
      return Colors.green; // Green color for debit card
  }
  return Colors.black; // Default color
}
