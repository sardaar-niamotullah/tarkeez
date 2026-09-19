import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/buttons/app_drawer_button.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback onAppMenuTap;

  const HomeAppBar({super.key, required this.onAppMenuTap});

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return SafeArea(
      child: Container(
        height: isIOS ? 36 : 48,
        padding: const .only(right: 16, left: 12),
        child: AppDrawerButton(onTap: onAppMenuTap),
      ),
    );
  }
}
