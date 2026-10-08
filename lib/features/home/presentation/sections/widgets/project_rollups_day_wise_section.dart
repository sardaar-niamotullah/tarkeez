import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/project_duration_tile.dart';

class ProjectRollupsDayWiseSection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final segments = [
      (flex: 50, color: scheme.primary),
      (flex: 40, color: scheme.secondary),
      (flex: 10, color: scheme.error),
    ];
    return Container(
      margin: .only(bottom: ContainerDesignUtils.margin),
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
          //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
          // Date title and total duration
          //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
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
          //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
          // Seperation line with percentage seperaton
          //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
          Row(
            children: [
              for (int i = 0; i < segments.length; i++)
                Expanded(
                  flex: segments[i].flex,
                  child: Container(
                    margin: .only(right: i == segments.length - 1 ? 0 : 4),
                    height: 4,
                    decoration: BoxDecoration(
                      color: segments[i].color,
                      borderRadius: ContainerDesignUtils.allRadius,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
          // Project's list
          //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
          const ProjectDurationTile(isActive: true),
          const ProjectDurationTile(isActive: false),
          const ProjectDurationTile(isActive: false),
          const ProjectDurationTile(isActive: false),
        ],
      ),
    );
  }
}
