import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/widgets/go_premium_dialog.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class LeaderboardFilterDurationSelectorButton extends StatelessWidget {
  const LeaderboardFilterDurationSelectorButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isSelected = false,
    this.isLocked = false,
  });

  final String title;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isLocked) {
            showDialog(context: context, builder: (_) => GoPremiumDialog());
            return;
          }
          onTap();
        },
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          height: 34,
          padding: .symmetric(horizontal: ContainerDesignUtils.padding),
          decoration: BoxDecoration(
            borderRadius: ContainerDesignUtils.allRadius,
            gradient: LinearGradient(
              begin: .centerLeft,
              end: .centerRight,
              colors: [
                isSelected
                    ? scheme.primaryContainer.withValues(alpha: .25)
                    : scheme.onSurface,
                isSelected
                    ? scheme.primary.withValues(alpha: .25)
                    : scheme.onSurface,
              ],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextUtils.paragraphSmallBold(context),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ),
              if (isLocked)
                SvgPicture.asset(
                  SvgPaths.lock,
                  height: 14,
                  colorFilter: .mode(
                    scheme.onTertiary.withValues(alpha: .9),
                    .srcIn,
                  ),
                ),
              if (isSelected)
                SvgPicture.asset(
                  SvgPaths.doneOutline,
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
