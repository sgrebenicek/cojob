import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
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
    );
  }
}
