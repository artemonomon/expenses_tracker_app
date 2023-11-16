import 'package:expenses_tracker_app/database/database.dart';
import 'package:expenses_tracker_app/models/models.dart';
import 'package:expenses_tracker_app/screens/add_account_screen.dart';
import 'package:expenses_tracker_app/widgets/floating_action_btn.dart';
import 'package:flutter/material.dart';

class PersonalAccountsScreen extends StatefulWidget {
  const PersonalAccountsScreen({super.key});

  @override
  State<PersonalAccountsScreen> createState() => _PersonalAccountsScreenState();
}

class _PersonalAccountsScreenState extends State<PersonalAccountsScreen> {
  late Future<List<PersonalAccount>> personalAccounts;
  final expensesDb = ExpensesAppDb();

  @override
  void initState() {
    super.initState();
    personalAccounts = fetchPersonalAccounts();
  }

  Future<List<PersonalAccount>> fetchPersonalAccounts() async {
    return expensesDb.getPersonalAccounts();
  }

  double calculateTotalBalance(List<PersonalAccount> accounts) {
    // Sum up the converted balances to UAH
    return accounts.fold(
      0,
      (previousValue, account) => previousValue + account.convertToUAH()!,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Мої рахунки'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<double>(
              future: personalAccounts.then(calculateTotalBalance),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('Немає даних');
                } else {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        bottom: 10, top: 10, left: 10, right: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Загальний баланс:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          '${snapshot.data!.toStringAsFixed(2)} UAH',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color:
                                snapshot.data! >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            FutureBuilder<List<PersonalAccount>>(
              future: personalAccounts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${snapshot.error}'),
                      ElevatedButton(
                        onPressed: () {
                          // Retry fetching data
                          setState(() {
                            personalAccounts = fetchPersonalAccounts();
                          });
                        },
                        child: const Text(
                            'Не вдалося завантажити дані. Спробувати ще раз'),
                      ),
                    ],
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'У вас ще немає жодного рахунку.\n',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Натисніть на + щоб додати.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        PersonalAccount account = snapshot.data![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: Icon(
                              getIconForCategory(account.category) ??
                                  Icons.account_balance,
                              color: getIconColorForCategory(account.category),
                            ),
                            title: Text(account.name!),
                            trailing: Text(
                              '${account.balance} ${account.currency}',
                              style: TextStyle(
                                color: account.balance! >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            onTap: () async {
                              // Navigate to the page to add a new personal account
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddAccountScreen(initialAccount: account),
                                ),
                              );

                              // Check if the result indicates an update is needed
                              if (result == true) {
                                setState(() {
                                  personalAccounts = fetchPersonalAccounts();
                                });
                              }
                            },
                            // Add more details as needed
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        marginBottom: height * 0.03,
        marginRight: 0,
        onPressed: () async {
          // Navigate to the page to add a new personal account
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddAccountScreen(),
            ),
          );

          // Check if the result indicates an update is needed
          if (result == true) {
            setState(() {
              personalAccounts = fetchPersonalAccounts();
            });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
