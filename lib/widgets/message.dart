import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.name, required this.content});
  final String name;
  final String content;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: GestureDetector(
        onTap: null,
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.person,
                  size: 50,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ) ??
                            GoogleFonts.openSans(
                              fontSize: 22,
                            ),
                      ),
                      Text(
                        content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ) ??
                            GoogleFonts.openSans(
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
