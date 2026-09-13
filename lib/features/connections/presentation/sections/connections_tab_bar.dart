import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class ConnectionsTabBar extends StatelessWidget {
  final TabController controller;

  const ConnectionsTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      pinned: false,
      floating: true,
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      toolbarHeight: 42,
      collapsedHeight: 42,
      flexibleSpace: FlexibleSpaceBar(
        background: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: Container(
            color: scheme.onSurface,
            child: TabBar(
              controller: controller,
              isScrollable: false,
              indicatorSize: .tab,
              indicatorColor: scheme.primary,
              indicatorWeight: 2.5,
              dividerColor: Colors.transparent,
              labelColor: scheme.primary,
              unselectedLabelColor: scheme.onTertiary,
              labelPadding: const .all(0),
              labelStyle: TextUtils.paragraphBold(context),
              unselectedLabelStyle: TextUtils.paragraphBold(context),
              tabs: const [
                Tab(text: 'Connections'),
                Tab(text: 'Requests'),
                Tab(text: 'Pending'),
                Tab(text: 'Explore'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
