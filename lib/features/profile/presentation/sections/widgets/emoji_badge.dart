import 'package:flutter/material.dart';

class EmojiBadge extends StatelessWidget {
  final String emoji;
  final bool isPrimary;
  const EmojiBadge({super.key, required this.emoji, this.isPrimary = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isPrimary ? 40 : 24,
      width: isPrimary ? 40 : .infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: isPrimary ? .circular(12) : null,
      ),
      child: Center(
        child: Text(emoji, style: TextStyle(fontSize: isPrimary ? 24 : 18)),
      ),
    );
  }
}
