import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class AppDrawerItem extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  final String title;
  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        context.pop();
        onTap();
      },
      mouseCursor: SystemMouseCursors.click,
      borderRadius: ContainerDesignUtils.allRadius,
      child: Padding(
        padding: .symmetric(
          horizontal: ContainerDesignUtils.padding,
          vertical: ContainerDesignUtils.halfPadding,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: .mode(scheme.onTertiary, .srcIn),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextUtils.paragraphBold(context, color: scheme.onTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
