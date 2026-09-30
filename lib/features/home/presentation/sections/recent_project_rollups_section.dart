import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/project_duration_tile.dart';

class RecentProjectRollupsSection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 8),
        const ProjectDurationTile(isActive: true),
      ],
    );
  }
}
