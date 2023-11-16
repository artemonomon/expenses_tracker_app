import 'package:expenses_tracker_app/models/expense.dart';
import 'package:expenses_tracker_app/models/income.dart';
import 'package:expenses_tracker_app/models/models.dart';
import 'package:flutter/material.dart';

import '../database/database.dart';

class AddActionScreen extends StatefulWidget {
  const AddActionScreen({super.key});

  @override
  State<AddActionScreen> createState() => _AddActionScreenState();
}

class _AddActionScreenState extends State<AddActionScreen> {
  PersonalAccount? selectedAccount;
  String selectedExpenseCategory = 'Харчування';
  String selectedIncomeCategory = 'Зарплата';
  String actionType = 'Витрати';
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final expensesDb = ExpensesAppDb();

  List<String> incomeCategories = [
    'Зарплата',
    'Подарунок',
    'Позика',
    'Інше',
  ];

  List<String> expenseCategories = [
    'Харчування',
    'Транспорт',
    'Розваги',
    'Одяг',
    'Подарунок',
    'Побут',
    'Здоров\'я',
    'Комунальні послуги',
    'Інше',
  ];

  @override
  void initState() {
    super.initState();
    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    List<PersonalAccount> accounts = await expensesDb.getPersonalAccounts();
    setState(() {
      selectedAccount =
          (accounts.isNotEmpty ? accounts.first : '') as PersonalAccount?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Додати ${actionType.toLowerCase()}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Назва'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Сума'),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<PersonalAccount>>(
              future: expensesDb.getPersonalAccounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No accounts available.');
                } else {
                  List<PersonalAccount> accounts = snapshot.data!;
                  return DropdownButtonFormField<PersonalAccount>(
                    value: selectedAccount,
                    onChanged: (PersonalAccount? value) {
                      setState(() {
                        selectedAccount = value;
                      });
                    },
                    items: accounts
                        .map(
                          (account) => DropdownMenuItem<PersonalAccount>(
                            value:
                                account, // Use the entire PersonalAccount object as the value
                            child: Text(account.name ?? ''),
                          ),
                        )
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Рахунок'),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            actionType == "Витрати"
                ? DropdownButtonFormField<String>(
                    value: selectedExpenseCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedExpenseCategory = value!;
                      });
                    },
                    items: expenseCategories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Категорія'),
                  )
                : DropdownButtonFormField<String>(
                    value: selectedIncomeCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedIncomeCategory = value!;
                      });
                    },
                    items: incomeCategories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Категорія'),
                  ),
            const SizedBox(height: 16),
            Row(
              children: [
                Radio(
                  value: 'Витрати',
                  groupValue: actionType,
                  onChanged: (value) {
                    setState(() {
                      actionType = value.toString();
                    });
                  },
                ),
                const Text('Витрати'),
                const SizedBox(width: 16),
                Radio(
                  value: 'Дохід',
                  groupValue: actionType,
                  onChanged: (value) {
                    setState(() {
                      actionType = value.toString();
                    });
                  },
                ),
                const Text('Дохід'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Add your logic to save the expense/income
                // You can access the entered data using titleController.text, amountController.text, etc.
                // Create an ExpenseAction or IncomeAction object based on the selected actionType
                if (actionType == 'Витрати') {
                  // Save expense
                  await expensesDb.insertExpense(
                    Expense(
                        title: titleController.text,
                        amount: double.tryParse(amountController.text) ?? 0.0,
                        category: selectedExpenseCategory,
                        date: DateTime.now(),
                        personalAccount: selectedAccount!),
                  );
                } else {
                  // Save income
                  await expensesDb.insertIncome(
                    Income(
                        title: titleController.text,
                        amount: double.tryParse(amountController.text) ?? 0.0,
                        date: DateTime.now(),
                        category: selectedIncomeCategory,
                        personalAccount: selectedAccount!),
                  );
                }

                // Optionally, you can navigate back to the previous screen after saving
                Navigator.pop(context, true);
              },
              child: const Text('Зберегти'),
            ),
          ],
        ),
      ),
    );
  }
}
