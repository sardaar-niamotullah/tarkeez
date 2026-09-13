import 'package:tarkeez/core/shared_files/cubits/navigation_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/main_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/features/home/presentation/home_tab.dart';
import 'package:tarkeez/features/home/presentation/sections/app_drawer.dart';
import 'package:tarkeez/features/profile/presentation/profile_tab.dart';
import 'package:tarkeez/features/projects/presentation/projects_tab.dart';
import 'package:tarkeez/features/report/presentation/report_tab.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      HomeTab(onMenuTap: _openDrawer),
      ReportTab(),
      ProjectsTab(),
      ProfileTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<NavigationCubit>().currentIndex;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: scheme.onSurface,

      // ────────────────────────────────────────────────────────────
      // App drawer
      // ────────────────────────────────────────────────────────────
      drawer: const AppDrawer(),

      // ────────────────────────────────────────────────────────────
      // Bottom nav bar
      // ────────────────────────────────────────────────────────────
      bottomNavigationBar: const MainBottomNavBar(),

      // ────────────────────────────────────────────────────────────
      // Body
      // ────────────────────────────────────────────────────────────
      body: IndexedStack(index: currentIndex, children: _tabs),
    );
  }
}
