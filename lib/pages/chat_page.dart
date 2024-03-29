import 'dart:async';

import 'package:cojob/pages/home_page.dart';
import 'package:cojob/pages/login_page.dart';
import 'package:cojob/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:cojob/api_service.dart';
import 'package:cojob/secure_storage.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final int receiverId;

  const ChatPage({super.key, required this.userName, required this.receiverId});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final _apiService = APIService();
  final SecureStorage _secureStorage = SecureStorage();
  final _messageController = TextEditingController();
  List<dynamic> _messages = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchMessages();
    refreshMessages();
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void refreshMessages() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _fetchMessages(),
    );
  }

  void _fetchMessages() async {
    final String? userId = await _secureStorage.getUserId();
    if (userId != null) {
      final messages =
          await _apiService.fetchMessages(int.parse(userId), widget.receiverId);
      if (messages != null) {
        setState(() {
          _messages = messages.reversed.toList();
        });
      }
    }
  }

  void _sendMessage() async {
    _checkLoginStatus();
    if (_messageController.text.isNotEmpty) {
      final success = await _apiService.sendMessage(
          widget.receiverId, _messageController.text);
      if (success) {
        _messageController.clear();
        _fetchMessages();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.background,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    ),
                  ),
                  Text(
                    widget.userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatMessage(
                  content: message['message'],
                  senderId: message['senderId'],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 4,
              right: 4,
              bottom: MediaQuery.of(context).viewPadding.bottom + 4,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: colorScheme.onSurface, fontSize: 18),
                        hintText: "Type a message...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: colorScheme.onSurface,
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
