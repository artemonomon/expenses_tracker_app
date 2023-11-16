import 'package:expenses_tracker_app/database/database.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class AddAccountScreen extends StatefulWidget {
  final PersonalAccount? initialAccount;

  const AddAccountScreen({super.key, this.initialAccount});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  String selectedCategory = 'Готівка';
  String selectedCurrency = 'UAH';
  TextEditingController nameController = TextEditingController();
  TextEditingController balanceController = TextEditingController();
  final expensesDb = ExpensesAppDb();

  @override
  void initState() {
    super.initState();
    if (widget.initialAccount != null) {
      selectedCategory = widget.initialAccount!.category!;
      selectedCurrency = widget.initialAccount!.currency!;
      nameController.text = widget.initialAccount!.name!;
      balanceController.text = widget.initialAccount!.balance.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialAccount == null
            ? 'Додати рахунок'
            : 'Редагувати рахунок'),
        centerTitle: true,
        actions: [
          if (widget.initialAccount != null)
            IconButton(
              onPressed: () async {
                // Show a confirmation dialog
                bool confirmDelete = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Ви впевнені?'),
                      content: const Text(
                          'Ви впевнені, що хочете видалити рахунок?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context, false); // Cancel the deletion
                          },
                          child: const Text('Ні'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context, true); // Confirm the deletion
                          },
                          child: const Text('Так'),
                        ),
                      ],
                    );
                  },
                );

                // Delete the account from the database if confirmed
                if (confirmDelete == true) {
                  expensesDb.deletePersonalAccount(widget.initialAccount!.id!);
                  Navigator.pop(context, true);
                }
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Назва рахунку'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Баланс'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCurrency,
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                });
              },
              items: ['UAH', 'USD', 'EUR']
                  .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      ))
                  .toList(),
              decoration: const InputDecoration(labelText: 'Валюта'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              items: ['Готівка', 'Кредитна карта', 'Дебетова карта']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              decoration: const InputDecoration(labelText: 'Категорія'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add or edit account in the database
                if (widget.initialAccount == null) {
                  // Add account to database
                  expensesDb.insertPersonalAccount(
                    PersonalAccount(
                      name: nameController.text,
                      balance: double.parse(balanceController.text),
                      currency: selectedCurrency,
                      category: selectedCategory,
                    ),
                  );
                } else {
                  // Edit account in the database
                  expensesDb.updatePersonalAccount(
                    widget.initialAccount!.copyWith(
                      name: nameController.text,
                      balance: double.parse(balanceController.text),
                      currency: selectedCurrency,
                      category: selectedCategory,
                    ),
                  );
                }
                Navigator.pop(context, true);
              },
              child:
                  Text(widget.initialAccount == null ? 'Зберегти' : 'Оновити'),
            ),
          ],
        ),
      ),
    );
  }
}
