import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomSheetCloseButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Positioned(
      top: -40,
      right: 16,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => context.pop(),
          mouseCursor: SystemMouseCursors.click,
          customBorder: const CircleBorder(),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: scheme.tertiary,
            child: Icon(
              Icons.close_rounded,
              size: 20,
              color: scheme.onTertiary.withValues(alpha: .8),
            ),
          ),
        ),
      ),
    );
  }
}
