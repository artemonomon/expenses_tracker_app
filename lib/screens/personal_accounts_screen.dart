import 'package:flutter/material.dart';

class PersonalAccountsScreen extends StatelessWidget {
  const PersonalAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мої рахунки'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your personal accounts data widget goes here

            ElevatedButton(
              onPressed: () {
                // Navigate to the page to add a new personal account
                // Navigator.push(context, MaterialPageRoute(builder: (context) => AddPersonalAccountPage()));
              },
              child: Text('Add Personal Account'),
            ),
          ],
        ),
      ),
    );
  }
}
