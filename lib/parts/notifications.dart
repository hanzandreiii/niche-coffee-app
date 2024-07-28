import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotifLog extends StatefulWidget {
  final String log;
  final String notif;
  final String email;
  const NotifLog({
    super.key,
    required this.log,
    required this.notif,
    required this.email,
  });

  @override
  State<NotifLog> createState() => _NotifLogState();
}

class _NotifLogState extends State<NotifLog> {
  Future addUserDetails() async {
    await FirebaseFirestore.instance
        .collection('/users')
        .doc(widget.email)
        .collection('/logs')
        .doc('something')
        .set({
      'log': widget.log,
      'notif': widget.notif,
      'date': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(widget.email);
    throw addUserDetails();
  }
}
