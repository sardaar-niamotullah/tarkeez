import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/subscription/presentation/sections/widgets/package_title_tile.dart';

class CurrentPackageTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color color;
  final Color colorBright;

  const CurrentPackageTile({
    super.key,
    required this.title,
    required this.iconPath,
    required this.color,
    required this.colorBright,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            'Current package',
            style: TextUtils.paragraph(context, color: scheme.onTertiary),
          ),

          PackageTitleTile(
            title: title,
            iconPath: iconPath,
            color: color,
            colorBright: colorBright,
          ),
        ],
      ),
    );
  }
}
