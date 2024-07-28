import 'package:flutter/material.dart';

class MyButtonColor extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color btColor;
  const MyButtonColor({
    super.key,
    required this.onTap,
    required this.text,
    required this.btColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: btColor,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
