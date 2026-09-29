import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/features/report/presentation/sections/report_filter_tile.dart';
import 'package:tarkeez/features/report/presentation/sections/sessions_section.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StandAlonePageOuterStructure(
      title: 'Sessions',
      actions: [ActionPageIcon(iconPath: SvgPaths.sessions)],
      horizontalPadding: 0,

      // ──────────────────────────────────────────────────────────
      // Body content.
      // ──────────────────────────────────────────────────────────
      content: CustomScrollView(
        slivers: [
          const ReportFilterTile(),
          SliverPadding(
            padding: .symmetric(horizontal: ContainerDesignUtils.padding),
            sliver: const SessionsSection(isLocked: false),
          ),
        ],
      ),
    );
  }
}
