import 'package:flutter/material.dart';

class LargeHeader extends StatelessWidget {
  final String text;
  const LargeHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.displayLarge;
    return Text(
      text,
      style: textStyle,
    );
  }
}
