import 'package:flutter/material.dart';
import 'package:the_end/screens/register.dart';
import 'package:the_end/screens/login.dart';

class LogorRegPage extends StatefulWidget {
  const LogorRegPage({super.key});

  @override
  State<LogorRegPage> createState() => _LogorRegPageState();
}

class _LogorRegPageState extends State<LogorRegPage> {
  bool showLoginPage = true;

  //show login or register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(
        onTap: togglePages,
      );
    } else {
      return Register(
        onTap: togglePages,
      );
    }
  }
}
