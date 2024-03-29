// ignore_for_file: use_build_context_synchronously

import 'package:cojob/pages/chat_page.dart';
import 'package:cojob/pages/login_page.dart';
import 'package:cojob/pages/settings_page.dart';
import 'package:cojob/secure_storage.dart';
import 'package:cojob/widgets/bottom_navbar.dart';
import 'package:cojob/widgets/last_message.dart';
import 'package:cojob/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:cojob/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _apiService = APIService();
  final SecureStorage _secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await _secureStorage.getToken();
    if (token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.logout_outlined,
                        size: 30,
                      ),
                      onPressed: () async {
                        _apiService.logoutUser();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>?>(
                  future: _apiService.fetchAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching users'));
                    } else {
                      final users = snapshot.data ?? [];
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Message(
                            name: '${user['firstName']} ${user['lastName']}',
                            content: LastMessage(user: user),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    receiverId: user['id'],
                                    userName:
                                        '${user['firstName']} ${user['lastName']}',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
