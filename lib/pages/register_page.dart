import 'package:cojob/pages/login_page.dart';
import 'package:cojob/validators/password_validator.dart';
import 'package:flutter/material.dart';
import 'package:cojob/validators/email_validator.dart';

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
            const Text(
              'Register',
              style: TextStyle(fontSize: 50),
            ),
            //First Name
            TextFormField(
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            //Last Name
            TextFormField(
              decoration: const InputDecoration(labelText: 'Last Name'),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
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
