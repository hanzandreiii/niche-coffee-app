import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_end/parts/my_button.dart';
import 'package:the_end/parts/my_textfield.dart';
import 'package:the_end/parts/square_tile.dart';

//COLORS:
//Color(0XFF3D3128), brown
//color: Color(0XFFBBB9A9), olive

class Register extends StatefulWidget {
  final Function()? onTap;
  Register({super.key, required this.onTap});

  static String greet = '';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final usersCollection = FirebaseFirestore.instance.collection('/users');

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final usernameController = TextEditingController();

  final now = TimeOfDay.now();

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      //create user
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        addUserDetails(
          emailController.text.trim(),
          usernameController.text.trim(),
          1.00,
          0,
          0,
        );
        addLog();
      } else if (passwordController.text != confirmPasswordController.text) {
        showErrorMessage("Passwords don't Match");
      }
      /*} else if (checkUserExists(usernameController.toString())) {
        showErrorMessage("Username already exists");
      }*/
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  Future addLog() async {
    await FirebaseFirestore.instance
        .collection('/users')
        .doc(emailController.text)
        .collection('/logs')
        .add({
      'log': emailController.text + ' has registered to the application',
      'notif':
          'Welcome to Niche! Thank you for your continued support to our application',
      'date': DateFormat.yMMMMEEEEd().format(DateTime.now()) +
          ', ' +
          DateFormat.Hms().format(DateTime.now()),
    });
  }

  Future addUserDetails(String email, String username, double score,
      double currency, int reports) async {
    await FirebaseFirestore.instance.collection('/users').doc(email).set({
      'username': username,
      'trustscore': score,
      'currency': currency,
      'reports': reports,
    });
  }

  //error message
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0XFF5D7352),
          title: Center(
            child: Text(
              message,
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
      backgroundColor: const Color(0XFF5D7352),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                //greeting
                const Text(
                  'Welcome to Niche, please enter the following details.',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    color: Color(0XFFBBB9A9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),

                //title
                //email
                MyTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                //username
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                //password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 20),
                //confirm password
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                //signup
                //forgot password

                const SizedBox(height: 20),

                //sign in button
                const SizedBox(height: 20),
                MyButton(
                  onTap: signUserUp,
                  text: 'Sign Up',
                ),
                //google/fb
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      /*const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                              color: Color.fromARGB(173, 223, 223, 223)),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(173, 223, 223, 223),
                        ),
                      ),*/
                    ],
                  ),
                ),

                /*const SizedBox(height: 50),
            
                // google + apple sign in buttons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(imagePath: 'lib/images/google.png'),
            
                    SizedBox(width: 5),
            
                    // apple button
                    SquareTile(imagePath: 'lib/images/fb.png')
                  ],
                ),*/
                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Color.fromARGB(255, 221, 221, 221),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
