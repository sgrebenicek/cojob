import 'package:cojob/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key, required this.content, required this.senderId});

  final String content;
  final int senderId;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final _secureStorage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _secureStorage.getUserId(),
      builder: (context, snapshot) {
        final userId = snapshot.data;
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        Alignment alignment = widget.senderId.toString() != userId
            ? Alignment.centerLeft
            : Alignment.centerRight;
        Color backgroundColor = widget.senderId.toString() != userId
            ? colorScheme.surfaceVariant
            : colorScheme.inversePrimary;

        return Align(
          alignment: alignment,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.content,
                    style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ) ??
                        GoogleFonts.openSans(
                          fontSize: 16,
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
