import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_end/parts/my_textfield.dart';
import 'package:the_end/parts/notifications.dart';
import 'package:the_end/screens/curvednavbar.dart';
import 'package:the_end/screens/profile.dart';

import '../parts/my_button.dart';

class Reports extends StatefulWidget {
  final String log;
  final String notif;
  final String complainant;
  final String respondent;
  final String subject;
  final double value;

  Reports({
    super.key,
    required this.log,
    required this.notif,
    required this.complainant,
    required this.respondent,
    required this.subject,
    required this.value,
  });

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final reasonController = TextEditingController();

  void sendReport() async {
    try {
      //create user
      if (reasonController.text != "") {
        addUserDetails();
        addLog();
        NotifLog(
          log: "Appeal",
          notif: "Notif",
          email: widget.complainant.toString(),
        );
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Report has been sent!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const curvednavbar();
                    }),
                  );
                },
                child: Text('Close'),
              )
            ],
          ),
        );
      } else if (reasonController.text.trim() == "") {
        AlertDialog alert =
            AlertDialog(title: Text("Reason must not be empty."));
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
      /*} else if (checkUserExists(usernameController.toString())) {
        showErrorMessage("Username already exists");
      }*/
    } catch (e) {
      print(e);
    }
  }

  Future addUserDetails() async {
    await FirebaseFirestore.instance.collection('/reports').add({
      'complainant': widget.complainant,
      'respondent': widget.respondent,
      'reason': reasonController.text.trim(),
      'subject': widget.subject,
      'value': widget.value,
      'date': DateFormat.yMMMMEEEEd().format(DateTime.now()) +
          ', ' +
          DateFormat.Hms().format(DateTime.now()),
    });
  }

  //logs for notifs
  Future addLog() async {
    await FirebaseFirestore.instance
        .collection('/users')
        .doc(widget.complainant)
        .collection('/logs')
        .add({
      'log': widget.log,
      'notif': widget.notif,
      'date': DateFormat.yMMMMEEEEd().format(DateTime.now()) +
          ', ' +
          DateFormat.Hms().format(DateTime.now()),
    });
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
            textAlign: TextAlign.left,
            'Complainant: ${widget.complainant}\n\nRespondent: ${widget.respondent}\n\nSubject: ${widget.subject}',
            style: TextStyle(color: Color(0XFFBBB9A9), fontSize: 23),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 300,
            width: 400,
            child: TextField(
              controller: reasonController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: const Color.fromARGB(173, 223, 223, 223),
                  filled: true,
                  hintText: 'Please state the reason for the report...',
                  hintStyle: TextStyle(color: Colors.grey[600])),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          MyButton(
            onTap: sendReport,
            text: 'Send Report',
          ),
        ],
      ),
    );
  }
}
