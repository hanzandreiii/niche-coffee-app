import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_end/parts/my_button.dart';
import 'package:the_end/parts/my_textfield.dart';
import 'package:the_end/parts/square_tile.dart';
import 'package:the_end/screens/forgotpassword.dart';
import 'package:the_end/screens/reports.dart';

//COLORS:
//Color(0XFF3D3128), brown
//color: Color(0XFFBBB9A9), olive

class Login extends StatefulWidget {
  final Function()? onTap;
  Login({super.key, required this.onTap});

  static String greet = '';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final now = TimeOfDay.now();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
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
                const SizedBox(height: 20),
                //greeting
                const Text(
                  'Good morning, let\'s help you',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    color: Color(0XFFBBB9A9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                //logo
                Image.asset('lib/images/nichelogo.png', scale: 2.2),

                const SizedBox(height: 20),

                //title
                //username
                MyTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  obscureText: false,
                ),

                const SizedBox(height: 20),

                //password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                //signup
                //forgot password

                const SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ForgotPassword();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color.fromARGB(173, 223, 223, 223),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //sign in button
                const SizedBox(height: 20),
                MyButton(
                  onTap: signUserIn,
                  text: 'Sign In',
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
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
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
