import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class BottomSheetOptionTile extends StatelessWidget {
  final String title, iconPath;
  final VoidCallback onTap;
  final bool isLastTile, isActive;

  const BottomSheetOptionTile({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.isLastTile = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const SizedBox(height: 2),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: ContainerDesignUtils.allRadius,
            child: Padding(
              padding: const .symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextUtils.title3Normal(
                      context,
                      color: isActive ? scheme.primary : null,
                    ),
                  ),
                  SvgPicture.asset(
                    iconPath,
                    colorFilter: .mode(
                      isActive
                          ? scheme.primary.withValues(alpha: .8)
                          : scheme.onTertiary.withValues(alpha: .8),
                      .srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        if (!isLastTile)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 86,
            endIndent: 86,
            color: scheme.outline.withValues(alpha: .15),
          ),
      ],
    );
  }
}
