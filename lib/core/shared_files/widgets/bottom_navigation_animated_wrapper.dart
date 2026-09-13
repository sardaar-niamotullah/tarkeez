import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/primary_page_margin.dart';

class BottomNavigationAnimatedWrapper extends StatelessWidget {
  final Widget child;
  const BottomNavigationAnimatedWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: ContainerDesignUtils.topRadius,
      ),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        padding: .only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SafeArea(
          top: false,
          child: PrimaryPageMargin(
            child: Column(
              mainAxisSize: .min,
              children: [const SizedBox(height: 8), child],
            ),
          ),
        ),
      ),
    );
  }
}
