import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/enums/user_preference_enums.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/sliver_scroll_max_width_box.dart';
import 'package:tarkeez/features/report/presentation/sections/sessions_section.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/sessions_filter_tile.dart';

class SessionsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  late final _bloc = context.read<SessionBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.add(FetchSessionsForPeriodRequested(PeriodRange.last5Days));
  }

  @override
  void dispose() {
    _bloc.add(SessionsCleared());
    super.dispose();
  }

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
        slivers: [const SessionsFilterTile(), const SessionsSection()],
      ),
    );
  }
}
