import 'package:expenses_tracker_app/database/database.dart';
import 'package:expenses_tracker_app/models/models.dart';
import 'package:expenses_tracker_app/screens/screens.dart';
import 'package:expenses_tracker_app/widgets/floating_action_btn.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<Expense>> expenses;
  late Future<List<Income>> incomes;
  final expensesDb = ExpensesAppDb();
  bool showExpenses = true;
  double totalExpenses = 0;
  double totalIncomes = 0;

  @override
  void initState() {
    super.initState();
    expenses = fetchExpenses();
    incomes = fetchIncomes();
  }

  Future<List<Expense>> fetchExpenses() async {
    return expensesDb.getExpenses();
  }

  Future<List<Income>> fetchIncomes() async {
    return expensesDb.getIncomes();
  }

  double calculateTotalExpenses(List<Expense> expenses) {
    return expenses.fold(
      0,
      (previousValue, expense) => previousValue + expense.amount,
    );
  }

  double calculateTotalIncomes(List<Income> incomes) {
    return incomes.fold(
      0,
      (previousValue, income) => previousValue + income.amount,
    );
  }

  Map<String, CategoryInfo> expenseCategoryInfo = {
    'Харчування': CategoryInfo(Colors.red, LineIcons.utensils),
    'Транспорт': CategoryInfo(Colors.blue, Icons.directions_car),
    'Розваги': CategoryInfo(Colors.green, LineIcons.gamepad),
    'Одяг': CategoryInfo(Colors.orange, LineIcons.tShirt),
    'Подарунок': CategoryInfo(Colors.purple, LineIcons.gift),
    'Побут': CategoryInfo(Colors.pink, LineIcons.home),
    'Здоров\'я': CategoryInfo(Colors.teal, LineIcons.heartbeat),
    'Комунальні послуги': CategoryInfo(Colors.yellow, LineIcons.lightbulb),
    'Інше': CategoryInfo(Colors.grey, LineIcons.question),
    // Add other categories with their corresponding colors and icons
  };

  Map<String, CategoryInfo> incomeCategoryInfo = {
    'Зарплата': CategoryInfo(Colors.green, LineIcons.moneyBill),
    'Подарунок': CategoryInfo(Colors.blue, LineIcons.gifts),
    'Позика': CategoryInfo(Colors.orange, LineIcons.handHoldingUsDollar),
    'Інше': CategoryInfo(Colors.grey, LineIcons.question),
  };

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Головна'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          showExpenses ? Colors.black : Colors.grey),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                    onPressed: () {
                      setState(() {
                        showExpenses = true;
                      });
                    },
                    child: const Text('Витрати'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, top: 5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          showExpenses ? Colors.grey : Colors.black),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                    onPressed: () {
                      setState(() {
                        showExpenses = false;
                      });
                    },
                    child: const Text('Доходи'),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(
                  bottom: 10, right: 10, left: 10, top: 5),
              padding: const EdgeInsets.all(50),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FutureBuilder<List>(
                    future: showExpenses ? expenses : incomes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Помилка: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Expanded(child: Text('Немає даних'));
                      } else {
                        List data = snapshot.data as List;

                        return PieChart(
                          PieChartData(
                            sections: List.generate(
                              data.length,
                              (index) {
                                var item = data[index];
                                var categoryInfo = showExpenses
                                    ? expenseCategoryInfo[item.category]
                                    : incomeCategoryInfo[item.category];
                                return PieChartSectionData(
                                  color: categoryInfo?.color ?? Colors.grey,
                                  value: item.amount,
                                  radius: 50,
                                  showTitle: false,
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  FutureBuilder<double>(
                    future: showExpenses
                        ? expenses.then(calculateTotalExpenses)
                        : incomes.then(calculateTotalIncomes),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Помилка: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text('Немає даних');
                      } else {
                        if (showExpenses) {
                          totalExpenses = snapshot.data!;
                        } else {
                          totalIncomes = snapshot.data!;
                        }
                        return Text(
                          showExpenses
                              ? '-${totalExpenses.toStringAsFixed(2)} UAH'
                              : '+${totalIncomes.toStringAsFixed(2)} UAH',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: showExpenses ? Colors.red : Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List>(
            future: showExpenses ? expenses : incomes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Помилка: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Немає даних');
              } else {
                List data = snapshot.data as List;

                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    margin:
                        const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        // Use data[index] to get each Expense or Income object
                        var item = data[index];

                        return ListTile(
                          title: Text(
                            showExpenses ? item.title : item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: showExpenses
                                ? expenseCategoryInfo[item.category]?.color
                                : incomeCategoryInfo[item.category]?.color,
                            child: Icon(
                              showExpenses
                                  ? expenseCategoryInfo[item.category]?.icon
                                  : incomeCategoryInfo[item.category]?.icon,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                              showExpenses ? item.category : item.category),
                          trailing: Text(
                            showExpenses
                                ? '-${item.amount} UAH'
                                : '+${item.amount} UAH',
                            style: TextStyle(
                              color: showExpenses ? Colors.red : Colors.green,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddActionScreen(
                                  expenseToEdit: showExpenses ? item : null,
                                  incomeToEdit: showExpenses ? null : item,
                                ),
                              ),
                            );

                            if (result == true) {
                              setState(() {
                                expenses = fetchExpenses();
                                incomes = fetchIncomes();
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
          marginBottom: height * 0.42,
          marginRight: 16,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddActionScreen()),
            );

            if (result == true) {
              setState(() {
                expenses = fetchExpenses();
                incomes = fetchIncomes();
              });
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
