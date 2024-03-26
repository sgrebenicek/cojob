import 'dart:async';

import 'package:cojob/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:cojob/api_service.dart';
import 'package:cojob/secure_storage.dart';

class ChatPage extends StatefulWidget {
  final int receiverId;

  const ChatPage({super.key, required this.receiverId});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final _apiService = APIService();
  final _secureStorage = SecureStorage();
  final _messageController = TextEditingController();
  List<dynamic> _messages = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    refreshMessages();
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
          _messages = messages;
        });
      }
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final success = await _apiService.sendMessage(
          widget.receiverId, _messageController.text);
      if (success) {
        _messageController.clear();
        _fetchMessages(); // Refresh the message list after sending a message
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('Demo User',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
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
              bottom: MediaQuery.of(context).viewPadding.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: colorScheme.primary,
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
