import 'dart:async';

import 'package:cojob/api_service.dart';
import 'package:cojob/secure_storage.dart';
import 'package:flutter/material.dart';

class LastMessage extends StatefulWidget {
  final dynamic user;

  const LastMessage({super.key, required this.user});

  @override
  LastMessageState createState() => LastMessageState();
}

class LastMessageState extends State<LastMessage> {
  final _apiService = APIService();
  String _lastMessage = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchLastMessage();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => _fetchLastMessage());
  }

  void _fetchLastMessage() async {
    final SecureStorage secureStorage = SecureStorage();
    final currentUserId = await secureStorage.getUserId();
    final lastMessage = await _apiService.fetchLastMessage(
        int.parse(currentUserId!), widget.user['id']);
    if (mounted) {
      setState(() {
        _lastMessage = lastMessage?['message'] ?? "No messages yet";
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_lastMessage);
  }
}
