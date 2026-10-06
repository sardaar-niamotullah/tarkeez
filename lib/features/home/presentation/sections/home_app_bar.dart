import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/app_drawer_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/utils/app_bar_utils.dart';

class HomeAppBar extends StatelessWidget {
  const new({super.key, required this.onAppMenuTap});

  final VoidCallback onAppMenuTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: appBarHeight(context),
        constraints: BoxConstraints(maxWidth: Breakpoints.lg),
        padding: .only(
          right: 16,
          left: context.md ? 20 : 12,
          bottom: context.md ? 16 : 0,
        ),
        child: Row(
          crossAxisAlignment: context.md ? .end : .center,
          mainAxisAlignment: .spaceBetween,
          children: [
            AppDrawerButton(onTap: onAppMenuTap),
            ActionPageIcon(iconPath: SvgPaths.iconTransparent),
          ],
        ),
      ),
    );
  }
}
