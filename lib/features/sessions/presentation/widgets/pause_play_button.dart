import 'package:flutter/material.dart';
import 'package:tarkeez/core/theme/theme.dart';

class PausePlayButton extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onTap;

  const PausePlayButton({
    super.key,
    required this.isRunning,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: isRunning ? AppTheme.crimsonTab : scheme.primary,
              shape: .circle,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded,
                key: ValueKey(isRunning),
                color: Colors.white,
                size: isRunning ? 44 : 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
