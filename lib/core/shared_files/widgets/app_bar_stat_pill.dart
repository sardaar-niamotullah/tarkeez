import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class AppBarStatPill extends StatelessWidget {
  final String count, iconPath;
  final VoidCallback onTap;
  const AppBarStatPill({
    super.key,
    required this.count,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: ContainerDesignUtils.allRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          padding: const .only(left: 12, right: 8, top: 6.5, bottom: 6.5),
          decoration: BoxDecoration(
            color: scheme.tertiary,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Row(
            children: [
              Text(
                count,
                style: TextUtils.title3(context, color: scheme.onTertiary),
              ),
              const SizedBox(width: 6),
              SvgPicture.asset(
                iconPath,
                height: 18,
                colorFilter: .mode(
                  scheme.onTertiary.withValues(alpha: .9),
                  .srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
