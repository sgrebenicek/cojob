import 'package:flutter/material.dart';
import 'app.dart';

import 'package:cojob/blocs/user_bloc.dart';
import 'package:cojob/models/user.dart';
import 'package:cojob/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _userBloc = UserBloc();

  @override
  void initState() {
    super.initState();
    _userBloc.fetchUsers();
  }

  @override
  void dispose() {
    _userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: StreamBuilder<List<User>>(
        stream: _userBloc.users,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final users = snapshot.data;
          return ListView.builder(
            itemCount: users!.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text(user.email),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createSampleUser();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createSampleUser() {
    final sampleUser = User(
      firstName: 'Petr',
      lastName: 'Kovar',
      email: 'john.doe@example.com',
      password: 'Ahoj12345*'
    );
    _userBloc.createUser(sampleUser);
  }
}