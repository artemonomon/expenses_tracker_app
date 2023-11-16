import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton(
      {super.key,
      required this.onPressed,
      required this.marginBottom,
      required this.marginRight});

  final VoidCallback onPressed;
  final double marginBottom;
  final double marginRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: marginBottom, right: marginRight),
          child: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            onPressed: onPressed,
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }
}
