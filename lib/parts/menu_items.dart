import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:the_end/parts/my_button.dart';
import 'package:the_end/parts/my_button_colour.dart';

final currentUser = FirebaseAuth.instance.currentUser!;

class MenuItems extends StatefulWidget {
  final String cafId;
  MenuItems({
    super.key,
    required this.cafId,
  });

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyButtonColor(
          onTap: () {
            addLog(1);
            addLogReal();
          },
          text: 'Empty',
          btColor: Colors.lightGreen,
        ),
        MyButtonColor(
          onTap: () {
            addLog(2);
            addLogReal();
          },
          text: 'Barely Empty',
          btColor: Colors.yellow,
        ),
        MyButtonColor(
          onTap: () {
            addLog(3);
            addLogReal();
          },
          text: 'Barely Crowded',
          btColor: Colors.amber,
        ),
        MyButtonColor(
          onTap: () {
            addLog(4);
            addLogReal();
          },
          text: 'Crowded',
          btColor: Colors.orange,
        ),
        MyButtonColor(
          onTap: () {
            addLog(5);
            addLogReal();
          },
          text: 'Full',
          btColor: Colors.red,
        ),
      ],
    );
  }

  Future addLogReal() async {
    await FirebaseFirestore.instance
        .collection('/users')
        .doc(currentUser.email)
        .collection('/logs')
        .add({
      'log': currentUser.email.toString() + ' has added a count',
      'notif': 'Thank you for helping the community by adding a cafe status.',
      'date': DateFormat.yMMMMEEEEd().format(DateTime.now()) +
          ', ' +
          DateFormat.Hms().format(DateTime.now()),
    });
  }

  Future addLog(amt) async {
    await FirebaseFirestore.instance
        .collection('markers')
        .doc(widget.cafId)
        .collection('crowd')
        .doc(
          DateFormat.yMMMMEEEEd().format(DateTime.now()) +
              ', ' +
              DateFormat.Hms().format(DateTime.now()),
        )
        .set({
      'submitter': currentUser.email.toString(),
      'people': amt.toString(),
    });
  }
}
