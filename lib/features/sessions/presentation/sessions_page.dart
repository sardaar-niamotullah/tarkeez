import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/sliver_scroll_max_width_box.dart';
import 'package:tarkeez/features/report/presentation/sections/sessions_section.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/sessions_filter_tile.dart';

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
      content: SliverScrollMaxWidthBox(
        slivers: [
          const SessionsFilterTile(),
          SliverPadding(
            padding: .symmetric(
              horizontal: context.lg ? 0 : ContainerDesignUtils.padding,
            ),
            sliver: const SessionsSection(isLocked: false),
          ),
        ],
      ),
    );
  }
}
