import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/stand_alone_page_outer_structure.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/primary_page_margin.dart';
import 'package:tarkeez/features/connections/presentation/sections/connections_tab_bar.dart';
import 'package:tarkeez/features/connections/presentation/sections/widgets/connections_user_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({super.key});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    // TabController fires this listener during the swipe/animation too,
    // so only rebuild once the tab has actually settled to avoid
    // redundant rebuilds mid-transition.
    if (!_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);

    return StandAlonePageOuterStructure(
      isLoading: false,
      title: texts.connections,
      horizontalPadding: 0,
      actions: [ActionPageIcon(iconPath: SvgPaths.users)],
      content: CustomScrollView(
        slivers: [
          ConnectionsTabBar(controller: _tabController),
          Skeletonizer.sliver(
            enabled: false,
            child: _buildListForTab(_currentTabIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildListForTab(int index) {
    switch (index) {
      case 0:
        return SliverList.builder(
          itemCount: 100,
          itemBuilder: (context, i) => PrimaryPageMargin(
            child: ConnectionsUserTile(
              isEvenTile: i % 2 == 0,
              crudConnectionType: .disconnectUser,
            ),
          ),
        );
      case 1: // Pending
        return SliverList.builder(
          itemCount: 20,
          itemBuilder: (context, i) => PrimaryPageMargin(
            child: ConnectionsUserTile(
              isEvenTile: i % 2 == 0,
              crudConnectionType: .acceptRequest,
            ),
          ),
        );
      case 2: // Sent
        return SliverList.builder(
          itemCount: 15,
          itemBuilder: (context, i) => PrimaryPageMargin(
            child: ConnectionsUserTile(
              isEvenTile: i % 2 == 0,
              crudConnectionType: .withdrawRequest,
            ),
          ),
        );
      case 3: // Users
        return SliverList.builder(
          itemCount: 100,
          itemBuilder: (context, i) => PrimaryPageMargin(
            child: ConnectionsUserTile(
              isEvenTile: i % 2 == 0,
              crudConnectionType: .sendRequest,
            ),
          ),
        );
      default:
        return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }
}
