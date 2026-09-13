import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/action_button.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/buttons/app_drawer_button.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback onAppMenuTap;

  const HomeAppBar({super.key, required this.onAppMenuTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 48,
        padding: const .only(right: 16, left: 12),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            AppDrawerButton(onTap: onAppMenuTap),
            Stack(
              clipBehavior: .none,
              children: [
                ActionButton(iconPath: SvgPaths.bell, onTap: () {}),
                Positioned(
                  top: 3,
                  right: -1,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
