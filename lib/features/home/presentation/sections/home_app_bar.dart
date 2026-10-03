import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/shared_files/buttons/app_drawer_button.dart';

class HomeAppBar extends StatelessWidget {
  const new({super.key, required this.onAppMenuTap});

  final VoidCallback onAppMenuTap;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return SafeArea(
      child: Container(
        height: context.lg
            ? 124
            : context.md
            ? 84
            : isIOS
            ? 34
            : 48,
        constraints: BoxConstraints(maxWidth: Breakpoints.lg),
        padding: .only(right: 16, left: 12, bottom: context.md ? 16 : 0),
        child: Align(
          alignment: context.md ? .bottomStart : .center,
          child: AppDrawerButton(onTap: onAppMenuTap),
        ),
      ),
    );
  }
}
