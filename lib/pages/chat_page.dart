import 'package:cojob/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:cojob/pages/home_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ChatMessage(
          content:
              'We have defined simply a Stateless widget which acts as a simple button that uses a GestureDetector to detect the functions and also accepts an icon as the child to be displayed inside the button. It is a rounded button with a fixed height and width. We can alter the color if we need it, but it already has a custom color of translucent white.'),
    );
  }
}
