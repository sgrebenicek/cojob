import 'package:cojob/pages/home_page.dart';
import 'package:cojob/pages/login_page.dart';
import 'package:cojob/variables/themes.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      theme: mainTheme,
    );
  }
}
