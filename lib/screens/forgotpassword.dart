import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_end/parts/my_textfield.dart';

import '../parts/my_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password reset link sent, please check your E-mail'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message.toString());
    }
  }

  void showErrorMessage(String e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0XFF5D7352),
          title: Center(
            child: Text(
              e,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF5D7352),
      appBar: AppBar(
        backgroundColor: Color(0XFF5D7352),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            'Enter your E-mail and we will send you a password reset link',
            style: TextStyle(
                fontFamily: 'Lora', color: Color(0XFFBBB9A9), fontSize: 16),
          ),
          const SizedBox(height: 40),
          MyTextField(
            controller: emailController,
            hintText: 'E-mail',
            obscureText: false,
          ),
          const SizedBox(height: 30),
          MyButton(
            onTap: passwordReset,
            text: 'Reset Password',
          ),
        ],
      ),
    );
  }
}
