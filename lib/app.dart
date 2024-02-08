import 'package:cojob/pages/login_page.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'cojob';

    return const MaterialApp(
      title: appTitle,
      home: Scaffold(
        body: LoginForm(),
      ),
    );
  }
}
