import 'package:cojob/pages/login_page.dart';
import 'package:cojob/validators/password_validator.dart';
import 'package:flutter/material.dart';
import 'package:cojob/validators/email_validator.dart';
import 'package:cojob/variables/text_sizes.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const LargeHeader(text: 'Register'),
            //First Name
            TextFormField(
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your first name';
                }
                return null;
              },
            ),
            //Last Name
            TextFormField(
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your last name';
                }
                return null;
              },
            ),
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
                if (!value.isValidPassword()) {
                  return passwordRequirements;
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_registerFormKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginForm()),
                    );
                  }
                },
                child: const Text('Register'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginForm()),
                );
              },
              child: const Text('Already have an account? Login here.'),
            )
          ],
        ),
      ),
    );
  }
}
