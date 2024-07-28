import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_end/screens/settings.dart';

import 'firebase_options.dart';
import 'screens/curvednavbar.dart';
import 'screens/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Auth(),
      /*routes: {
        '/loginpage': (context) => Login(),
        '/homepage': (context) => MapPage(),
        '/shoppage': (context) => Shop(),
        '/settingspage': (context) => Settings(),
        '/profilepage': (context) => ProfilePage(),
        '/notifspage': (context) => Notifs(),
      },*/
    );
  }
}
