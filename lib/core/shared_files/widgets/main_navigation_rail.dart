import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/navigation_cubit.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/bottom_nav_bar_icon.dart';

class MainNavigationRail extends StatelessWidget {
  const new({
    super.key,
    required this.onMenuTap,
    required this.isMenuOpen,
    this.showMenu = false,
  });

  final VoidCallback onMenuTap;
  final bool isMenuOpen;

  /// Show the extra "Menu" destination (index 4), like the bottom bar does on small screens.
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tabIndex = context.watch<NavigationCubit>().currentIndex;
    final currentIndex = isMenuOpen ? 4 : tabIndex;

    return Material(
      color: scheme.surface,
      elevation: 8,
      child: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: InkRipple.splashFactory,
            splashColor: scheme.primary.withValues(alpha: .01),
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: NavigationRail(
            backgroundColor: Colors.transparent,
            // ────────────────────────────────────────────────────────────
            // Navigation logic
            // ────────────────────────────────────────────────────────────
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              if (index == 4) {
                onMenuTap();
                return;
              }
              context.read<NavigationCubit>().navigateTo(
                NavigationTab.values[index],
              );
            },
            labelType: NavigationRailLabelType.all,
            useIndicator: false,
            selectedIconTheme: IconThemeData(color: scheme.primary),
            unselectedIconTheme: IconThemeData(color: scheme.onTertiary),
            selectedLabelTextStyle: TextUtils.paragraphSmallBold(
              context,
              color: scheme.primaryContainer,
            ),
            unselectedLabelTextStyle: TextUtils.paragraphSmallBold(
              context,
              color: scheme.onTertiary,
            ),
            destinations: [
              NavigationRailDestination(
                icon: BottomNavBarIcon(
                  iconPath: SvgPaths.home,
                  isActive: currentIndex == 0,
                ),
                label: const Text('Home'),
              ),
              NavigationRailDestination(
                icon: BottomNavBarIcon(
                  iconPath: SvgPaths.pieChart,
                  isActive: currentIndex == 1,
                ),
                label: const Text('Reports'),
              ),
              NavigationRailDestination(
                icon: BottomNavBarIcon(
                  iconPath: SvgPaths.projects,
                  isActive: currentIndex == 2,
                ),
                label: const Text('Projects'),
              ),
              NavigationRailDestination(
                icon: BottomNavBarIcon(
                  iconPath: SvgPaths.user,
                  isActive: currentIndex == 3,
                ),
                label: const Text('Profile'),
              ),
              if (showMenu)
                NavigationRailDestination(
                  icon: BottomNavBarIcon(
                    iconPath: SvgPaths.hamburger,
                    isActive: currentIndex == 4,
                  ),
                  label: const Text('Menu'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
