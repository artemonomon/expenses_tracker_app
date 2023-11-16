import 'package:expenses_tracker_app/database/database.dart';
import 'package:expenses_tracker_app/screens/screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    MainScreen(),
    PersonalAccountsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize database
    DatabaseService databaseService = DatabaseService();
    databaseService.database;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Трекер витрат',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Головна',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Мої рахунки',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профіль',
            ),
          ],
        ),
      ),
    );
  }
}
