import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class TechPlatfromCard extends StatelessWidget {
  final String title, iconPath;

  const TechPlatfromCard({
    super.key,
    required this.title,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 36,
            colorFilter: .mode(scheme.onTertiary.withValues(alpha: .8), .srcIn),
          ),
          const SizedBox(height: 8),
          Text(title, style: TextUtils.title3(context)),
        ],
      ),
    );
  }
}
