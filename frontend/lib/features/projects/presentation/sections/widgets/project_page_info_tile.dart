import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class ProjectPageInfoTile extends StatelessWidget {
  const ProjectPageInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: .symmetric(
        horizontal: ContainerDesignUtils.padding,
        vertical: ContainerDesignUtils.halfPadding,
      ),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Row(
        children: [
          Container(
            padding: .all(ContainerDesignUtils.halfPadding),
            decoration: BoxDecoration(
              color: AppTheme.lightningGold.withValues(alpha: .1),
              borderRadius: ContainerDesignUtils.allRadius,
            ),
            child: SvgPicture.asset(
              SvgPaths.lightBulb,
              colorFilter: .mode(AppTheme.lightningGold, .srcIn),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Assign time to a project to see where it really invested: study, work, exercise, and more. Unassigned time falls under \'No project\' automatically.',
              style: TextUtils.paragraphSmall(context),
            ),
          ),
        ],
      ),
    );
  }
}
