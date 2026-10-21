import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class PackageTitleTile extends StatelessWidget {
  final String title, iconPath;
  final Color color, colorBright;

  const PackageTitleTile({
    super.key,
    required this.title,
    required this.iconPath,
    required this.color,
    required this.colorBright,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const .all(4),
      decoration: BoxDecoration(
        borderRadius: ContainerDesignUtils.allRadius,
        gradient: LinearGradient(
          begin: .topLeft,
          end: .bottomRight,
          colors: [colorBright, color],
        ),
      ),
      child: Row(
        mainAxisAlignment: .spaceAround,
        children: [
          Text(
            title,
            style: TextUtils.paragraphBold(context, color: AppTheme.white),
          ),
          SvgPicture.asset(
            iconPath,
            colorFilter: .mode(AppTheme.white, .srcIn),
          ),
        ],
      ),
    );
  }
}
