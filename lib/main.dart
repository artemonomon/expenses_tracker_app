import 'package:dot_navigation_bar/dot_navigation_bar.dart';
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Трекер витрат',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          body: _screens[_currentIndex],
          extendBody: true,
          bottomNavigationBar: DotNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              DotNavigationBarItem(
                icon: const Icon(Icons.home),
                selectedColor: Colors.deepPurple,
              ),
              DotNavigationBarItem(
                icon: const Icon(Icons.account_balance_wallet),
                selectedColor: Colors.deepPurple,
              ),
              DotNavigationBarItem(
                icon: const Icon(Icons.person),
                selectedColor: Colors.deepPurple,
              ),
            ],
          )),
    );
  }
}
