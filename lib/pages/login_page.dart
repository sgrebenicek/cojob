import 'package:cojob/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:cojob/validators/email_validator.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                  if (_loginFormKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Login'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterForm()),
                );
              },
              child: const Text('Do not have an account yet? Register here.'),
            )
          ],
        ),
      ),
    );
  }
}
