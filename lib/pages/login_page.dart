import 'package:cojob/app.dart';
import 'package:cojob/pages/register_page.dart';
import 'package:cojob/variables/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:cojob/validators/email_validator.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _loginPageKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _loginPageKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const LargeHeader(text: 'Login'),
            //Email Address
            TextFormField(
              decoration: const InputDecoration(labelText: ('Email Address')),
              validator: (value) {
                if (!value.isValidEmail()) {
                  return emailRequirements;
                }
                return null;
              },
            ),
            //Password
            TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: ('Password')),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your password';
                  }
                  return null;
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_loginPageKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  }
                },
                child: const Text('Login'),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Do not have an account yet? Register here.',
                  style: TextStyle(color: Color.fromARGB(255, 3, 39, 244)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
