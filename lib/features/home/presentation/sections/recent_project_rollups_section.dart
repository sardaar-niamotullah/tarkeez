import 'package:flutter/material.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/project_rollups_day_wise_section.dart';

class RecentProjectRollupsSection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProjectRollupsDayWiseSection(),
        ProjectRollupsDayWiseSection(),
      ],
    );
  }
}
