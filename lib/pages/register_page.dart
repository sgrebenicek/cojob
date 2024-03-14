import 'package:cojob/pages/login_page.dart';
import 'package:cojob/variables/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:cojob/models/user.dart';
import 'package:cojob/api_service.dart';
import 'package:cojob/validators/email_validator.dart';
import 'package:cojob/validators/password_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const LargeHeader(text: 'Register'),
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (!value.isValidEmail()) {
                  return emailRequirements;
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (!value.isValidPassword()) {
                  return passwordRequirements;
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    createUser();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Already have an account? Login here.',
                  style: TextStyle(color: Color.fromARGB(255, 3, 39, 244)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createUser() {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    User newUser = User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    ApiService.createUser(newUser).then((_) {
      print('User created successfully');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }).catchError(
      (err) {
        print('Failed to create user: $err');
        if (err == 111) {
          print('Conn error');
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('This email is already taken.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
