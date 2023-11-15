import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String routeName = '/main';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Головна'),
        ),
        body: Center(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the page to add a new expense
            // Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpensePage()));
          },
          child: const Icon(Icons.add),
        ));
  }
}
