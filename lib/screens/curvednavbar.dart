import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:the_end/screens/notifs.dart';
import 'package:the_end/screens/profile.dart';
import 'package:the_end/screens/settings.dart';
import 'package:the_end/screens/shop.dart';
import 'package:the_end/screens/home.dart';

class curvednavbar extends StatefulWidget {
  const curvednavbar({super.key});

  @override
  State<curvednavbar> createState() => _curvednavbarState();
}

class _curvednavbarState extends State<curvednavbar> {
  int _index = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color(0XFFFEF7FF),
          buttonBackgroundColor: const Color(0XFF5D7352),
          color: const Color(0XFF5D7352),
          animationDuration: const Duration(milliseconds: 300),
          index: 2,
          onTap: (value) {
            setState(() {
              _index = value;
            });
          },
          items: const <Widget>[
            Icon(Icons.shop, size: 26, color: Color(0XFFFFF2E3)),
            Icon(Icons.notifications, size: 26, color: Color(0XFFFFF2E3)),
            Icon(Icons.home, size: 26, color: Color(0XFFFFF2E3)),
            Icon(Icons.person_2_rounded, size: 26, color: Color(0XFFFFF2E3)),
            Icon(Icons.settings, size: 26, color: Color(0XFFFFF2E3)),
          ],
        ),
        body: Container(
          color: const Color(0XFFFEF7FF),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: getSelectedWidget(index: _index),
        ));
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget = const Profile();
    switch (index) {
      case 0:
        widget = const Shop();
        break;
      case 1:
        widget = const Notifs();
        break;
      case 2:
        widget = const MapPage();
        break;
      case 3:
        widget = const Profile();
        break;
      case 4:
        widget = const Settings();
        break;
    }
    return widget;
  }
}
