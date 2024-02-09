import 'package:cojob/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cojob/variables/themes.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'cojob';
    return MaterialApp(
      theme: mainTheme,
      title: appTitle,
      home: const Scaffold(
        body: LoginForm(),
      ),
    );
  }
}
