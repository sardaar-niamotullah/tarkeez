import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';

class EmojiBadge extends StatelessWidget {
  final String emoji;
  final bool isPrimary;
  const EmojiBadge({super.key, required this.emoji, this.isPrimary = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPrimary ? null : .infinity,
      padding: isPrimary ? .symmetric(vertical: 6, horizontal: 8) : null,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: isPrimary ? ContainerDesignUtils.allRadius : null,
      ),
      child: Center(
        child: Text(emoji, style: TextStyle(fontSize: isPrimary ? 24 : 18)),
      ),
    );
  }
}
