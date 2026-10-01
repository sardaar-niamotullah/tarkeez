import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/responsive/responsive_context.dart';
import 'package:tarkeez/core/shared_files/cubits/navigation_cubit.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/bottom_nav_bar_icon.dart';

class MainBottomNavBar extends StatelessWidget {
  const new({super.key, required this.onMenuTap, required this.isMenuOpen});
  final VoidCallback onMenuTap;
  final bool isMenuOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tabIndex = context.watch<NavigationCubit>().currentIndex;
    final currentIndex = isMenuOpen ? 4 : tabIndex;

    return Material(
      color: scheme.surface,
      elevation: 8,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1524),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: InkRipple.splashFactory,
              splashColor: scheme.primary.withValues(alpha: .01),
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              // ────────────────────────────────────────────────────────────
              // Navigation logic
              // ────────────────────────────────────────────────────────────
              currentIndex: currentIndex,
              onTap: (index) {
                if (index == 4) {
                  onMenuTap();
                  return;
                }
                context.read<NavigationCubit>().navigateTo(
                  NavigationTab.values[index],
                );
              },
              type: .fixed,
              selectedItemColor: scheme.primary,
              unselectedItemColor: scheme.onTertiary,
              selectedLabelStyle: TextUtils.paragraphSmallBold(
                context,
                color: scheme.primaryContainer,
              ),
              unselectedLabelStyle: TextUtils.paragraphSmallBold(
                context,
                color: scheme.onTertiary,
              ),
              items: [
                // ────────────────────────────────────────────────────────────
                // Home tab
                // ────────────────────────────────────────────────────────────
                BottomNavigationBarItem(
                  icon: BottomNavBarIcon(
                    iconPath: SvgPaths.home,
                    isActive: currentIndex == 0,
                  ),
                  label: 'Home',
                ),
                // ────────────────────────────────────────────────────────────
                // Reports tab
                // ────────────────────────────────────────────────────────────
                BottomNavigationBarItem(
                  icon: BottomNavBarIcon(
                    iconPath: SvgPaths.pieChart,
                    isActive: currentIndex == 1,
                  ),
                  label: 'Reports',
                ),
                // ────────────────────────────────────────────────────────────
                // Projects tab
                // ────────────────────────────────────────────────────────────
                BottomNavigationBarItem(
                  icon: BottomNavBarIcon(
                    iconPath: SvgPaths.projects,
                    isActive: currentIndex == 2,
                  ),
                  label: 'Projects',
                ),
                // ────────────────────────────────────────────────────────────
                // Profile tab
                // ────────────────────────────────────────────────────────────
                BottomNavigationBarItem(
                  icon: BottomNavBarIcon(
                    iconPath: SvgPaths.user,
                    isActive: currentIndex == 3,
                  ),
                  label: 'Profile',
                ),

                // ────────────────────────────────────────────────────────────
                // Profile tab
                // ────────────────────────────────────────────────────────────
                if (context.sm)
                  BottomNavigationBarItem(
                    icon: BottomNavBarIcon(
                      iconPath: SvgPaths.hamburger,
                      isActive: currentIndex == 4,
                    ),
                    label: 'Menu',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
