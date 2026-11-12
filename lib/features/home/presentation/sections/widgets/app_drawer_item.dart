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
      borderRadius: ContainerDesignUtils.allRadius,
      child: ListTile(
        mouseCursor: SystemMouseCursors.click,
        leading: SvgPicture.asset(
          iconPath,
          colorFilter: .mode(scheme.onTertiary, .srcIn),
        ),
        title: Text(
          title,
          style: TextUtils.paragraphBold(context, color: scheme.onTertiary),
        ),
      ),
    );
  }
}
