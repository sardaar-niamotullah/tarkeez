import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/project_duration_tile.dart';

class RecentProjectRollupsSection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: .symmetric(
        horizontal: ContainerDesignUtils.padding,
        vertical: context.md ? ContainerDesignUtils.padding : 0,
      ),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text('Today', style: TextUtils.title2(context)),
              const DurationTextUtils(
                durationInSeconds: 65321,
                fontSizePrimary: 18,
                fontSizeSeconday: 14,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 4,
                width: 200,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: ContainerDesignUtils.allRadius,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                height: 4,
                width: 100,
                decoration: BoxDecoration(
                  color: scheme.secondary,
                  borderRadius: ContainerDesignUtils.allRadius,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                height: 4,
                width: 71,
                decoration: BoxDecoration(
                  color: scheme.error,
                  borderRadius: ContainerDesignUtils.allRadius,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ProjectDurationTile(isActive: true),
          const ProjectDurationTile(isActive: false),
          const ProjectDurationTile(isActive: false),
          const ProjectDurationTile(isActive: false),
        ],
      ),
    );
  }
}
