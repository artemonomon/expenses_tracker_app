import 'package:expenses_tracker_app/models/models.dart';
import 'package:flutter/material.dart';

import '../database/database.dart';

class CategoryInfo {
  final Color color;
  final IconData icon;

  CategoryInfo(this.color, this.icon);
}

class AddActionScreen extends StatefulWidget {
  final Expense? expenseToEdit;
  final Income? incomeToEdit;

  const AddActionScreen({
    super.key,
    this.expenseToEdit,
    this.incomeToEdit,
  });

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
    if (widget.expenseToEdit != null) {
      // Editing an expense
      actionType = 'Витрати';
      selectedAccount = widget.expenseToEdit!.personalAccount;
      selectedExpenseCategory = widget.expenseToEdit!.category;
      titleController.text = widget.expenseToEdit!.title;
      amountController.text = widget.expenseToEdit!.amount.toString();
    } else if (widget.incomeToEdit != null) {
      // Editing an income
      actionType = 'Дохід';
      selectedAccount = widget.incomeToEdit!.personalAccount;
      selectedIncomeCategory = widget.incomeToEdit!.category;
      titleController.text = widget.incomeToEdit!.title;
      amountController.text = widget.incomeToEdit!.amount.toString();
    }
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
        title: Text(widget.expenseToEdit != null || widget.incomeToEdit != null
            ? 'Редагувати ${actionType.toLowerCase()}'
            : 'Додати ${actionType.toLowerCase()}'),
        centerTitle: true,
        actions: [
          if (widget.expenseToEdit != null || widget.incomeToEdit != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Show a confirmation dialog before deleting
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Ви впевнені, що хочете видалити?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Ні'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Perform the delete operation
                            if (widget.expenseToEdit != null) {
                              await expensesDb
                                  .deleteExpense(widget.expenseToEdit!.id!);
                              Navigator.pop(context, true);
                            } else if (widget.incomeToEdit != null) {
                              await expensesDb
                                  .deleteIncome(widget.incomeToEdit!.id!);
                              Navigator.pop(context, true);
                            }

                            // Navigate back to the previous screen after deleting
                            Navigator.pop(context, true);
                          },
                          child: Text('Так'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
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
                if (widget.expenseToEdit != null) {
                  // Editing an expense
                  await expensesDb.updateExpense(
                    Expense(
                      id: widget.expenseToEdit!.id,
                      title: titleController.text,
                      amount: double.tryParse(amountController.text) ?? 0.0,
                      category: selectedExpenseCategory,
                      date: widget.expenseToEdit!.date,
                      personalAccount: selectedAccount!,
                    ),
                  );
                } else if (widget.incomeToEdit != null) {
                  // Editing an income
                  await expensesDb.updateIncome(
                    Income(
                      id: widget.incomeToEdit!.id,
                      title: titleController.text,
                      amount: double.tryParse(amountController.text) ?? 0.0,
                      date: widget.incomeToEdit!.date,
                      category: selectedIncomeCategory,
                      personalAccount: selectedAccount!,
                    ),
                  );
                } else {
                  // Adding a new expense or income
                  if (actionType == 'Витрати') {
                    await expensesDb.insertExpense(
                      Expense(
                        title: titleController.text,
                        amount: double.tryParse(amountController.text) ?? 0.0,
                        category: selectedExpenseCategory,
                        date: DateTime.now(),
                        personalAccount: selectedAccount!,
                      ),
                    );
                  } else {
                    await expensesDb.insertIncome(
                      Income(
                        title: titleController.text,
                        amount: double.tryParse(amountController.text) ?? 0.0,
                        date: DateTime.now(),
                        category: selectedIncomeCategory,
                        personalAccount: selectedAccount!,
                      ),
                    );
                  }
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
