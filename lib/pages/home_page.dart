// ignore_for_file: use_build_context_synchronously

import 'package:cojob/pages/chat_page.dart';
import 'package:cojob/pages/login_page.dart';
import 'package:cojob/secure_storage.dart';
import 'package:cojob/variables/text_sizes.dart';
import 'package:cojob/widgets/message.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.menu,
                        size: 30,
                      ),
                      onPressed: () async {
                        final SecureStorage secureStorage = SecureStorage();
                        await secureStorage.deleteToken();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: SearchBar(
                          leading: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.person_search_outlined,
                              size: 35,
                            ),
                          ),
                          hintText: 'Search user...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return const Message(
                      name: 'David Langer',
                      content:
                          'We have defined simply a Stateless widget which acts as a simple button that uses a GestureDetector to detect the functions and also accepts an icon as the child to be displayed inside the button. It is a rounded button with a fixed height and width. We can alter the color if we need it, but it already has a custom color of translucent white.',
                    );
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
