import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/navigation_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/navigation_rail_item.dart';

class MainNavigationRail extends StatelessWidget {
  const MainNavigationRail({
    super.key,
    required this.onMenuTap,
    required this.isMenuOpen,
    this.showMenu = false,
  });

  final VoidCallback onMenuTap;
  final bool isMenuOpen;
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tabIndex = context.watch<NavigationCubit>().currentIndex;
    final currentIndex = isMenuOpen ? 4 : tabIndex;

    VoidCallback onSelect(int index) {
      if (index == 4) return onMenuTap;
      return () => context.read<NavigationCubit>().navigateTo(
        NavigationTab.values[index],
      );
    }

    return Material(
      color: scheme.onSurface,
      elevation: 8,
      child: SafeArea(
        child: SizedBox(
          width: 88,
          child: Column(
            children: [
              const Spacer(),
              NavigationRailItem(
                onTap: onSelect(0),
                isActive: currentIndex == 0,
                label: 'Home',
                iconPath: SvgPaths.home,
              ),
              NavigationRailItem(
                onTap: onSelect(1),
                isActive: currentIndex == 1,
                label: 'Reports',
                iconPath: SvgPaths.pieChart,
              ),
              NavigationRailItem(
                onTap: onSelect(2),
                isActive: currentIndex == 2,
                label: 'Projects',
                iconPath: SvgPaths.projects,
              ),
              NavigationRailItem(
                onTap: onSelect(3),
                isActive: currentIndex == 3,
                label: 'Profile',
                iconPath: SvgPaths.user,
              ),
              const Spacer(),
              NavigationRailItem(
                onTap: onSelect(4),
                isActive: currentIndex == 4,
                label: 'Menu',
                iconPath: SvgPaths.hamburger,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
