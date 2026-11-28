import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/asset_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/app_drawer_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/utils/app_bar_utils.dart';

class HomeAppBar extends StatelessWidget {
  const new({super.key, required this.onAppMenuTap});

  final VoidCallback onAppMenuTap;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return SafeArea(
      bottom: false,
      child: Container(
        height: appBarHeight(context),
        constraints: BoxConstraints(maxWidth: Breakpoints.lg),
        padding: .only(
          right: 16,
          left: context.md ? 20 : 12,
          bottom: context.md ? 12 : 0,
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          crossAxisAlignment: context.md ? .end : .center,
          children: [
            Listener(
              behavior: .opaque,
              onPointerUp: (_) {
                if (!context.md) onAppMenuTap();
              },
              child: AppDrawerButton(),
            ),

            Listener(
              behavior: .opaque,
              onPointerUp: (_) {
                if (!context.md) onAppMenuTap();
              },
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () {},
                  customBorder: const CircleBorder(),
                  child: Transform.translate(
                    offset: Offset(0, !context.md && isIOS ? -2 : 0),
                    child: ActionPageIcon(
                      size: 28,
                      iconPath: AssetPaths.logoOriginal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
