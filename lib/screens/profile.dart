import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_end/parts/text_box.dart';
import 'package:the_end/parts/text_box_no_button.dart';
import 'package:the_end/screens/forgotpassword.dart';
import 'package:the_end/screens/reports.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final usersCollection = FirebaseFirestore.instance.collection('/users');

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: const Color(0XFF5D7352),
          title: Text(
            'Edit $field',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(newValue),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF5D7352),
        centerTitle: true,
        title: Text('Profile Page',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  scrollable: true,
                  backgroundColor: const Color(0XFF5D7352),
                  title: Text('TRUST FACTOR GUIDE',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                  content: const Text(
                      'The trust factor system is set up in order to ensure that users will use the app with its intended purpose.' +
                          '\n\n• 100 \t\t\t\tThank you for keeping Niche in tip-top shape!' +
                          '\n\n• 95 > \t\t\t\tYou made a few mistakes, nothing too serious.' +
                          '\n\n• 90 > \t\t\t\tPlease be careful with your inputs as it is upsetting other users.' +
                          '\n\n• 89 < \t\t\t\tYou may no longer put any more inputs, please submit an appeal if you have anything to dispute about your trust factor.',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 243, 243, 243))),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Reports(
                                log: currentUser.email! +
                                    ' has submitted an appeal for their trust factor.',
                                notif:
                                    'Your appeal about your trust factor has been recieved and is currently under review. Thank you for your patience.',
                                complainant: currentUser.email.toString(),
                                respondent: currentUser.email.toString(),
                                subject: "APPEAL",
                                value: 1.00,
                              );
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Submit an Appeal',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(
              Icons.help,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('/users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final int score = (userData['trustscore'] * 100).round();
            final String scorestring = score.toString();
            return ListView(
              children: [
                const SizedBox(height: 20),
                //trust score
                Center(
                  child: Text(
                    'Your current trust score is',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CircularPercentIndicator(
                  radius: 150,
                  lineWidth: 20,
                  percent: userData['trustscore'],
                  progressColor: const Color(0XFF5D7352),
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  center: Text(
                    scorestring,
                    style: TextStyle(
                      fontSize: 140,
                      color: const Color(0XFF5D7352),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                //username
                MyTextBox(
                  text: userData['username'],
                  sectionName: 'username',
                  onPressed: () => editField('username'),
                ),
                //email
                MyTextBoxNoButton(
                    text: currentUser.email.toString(), sectionName: 'e-mail'),
                SizedBox(height: 20),
                //change password
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
                    textAlign: TextAlign.center,
                    'Change Password?',
                    style: TextStyle(
                      color: Color.fromARGB(172, 94, 94, 94),
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
