import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/navigation_cubit.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/bottom_nav_bar_icon.dart';

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

    void onSelect(int index) {
      if (index == 4) {
        onMenuTap();
        return;
      }
      context.read<NavigationCubit>().navigateTo(NavigationTab.values[index]);
    }

    final items = <({String iconPath, String label})>[
      (iconPath: SvgPaths.home, label: 'Home'),
      (iconPath: SvgPaths.pieChart, label: 'Reports'),
      (iconPath: SvgPaths.projects, label: 'Projects'),
      (iconPath: SvgPaths.user, label: 'Profile'),
      if (showMenu) (iconPath: SvgPaths.hamburger, label: 'Menu'),
    ];

    return Material(
      color: scheme.surface,
      elevation: 8,
      child: SafeArea(
        child: SizedBox(
          width: 88,
          child: Column(
            children: [
              const SizedBox(height: 12),
              for (var i = 0; i < items.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: InkWell(
                    onTap: () => onSelect(i),
                    mouseCursor: SystemMouseCursors.click,
                    borderRadius: BorderRadius.circular(12),
                    splashFactory: InkRipple.splashFactory,
                    splashColor: scheme.primary.withValues(alpha: .01),
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BottomNavBarIcon(
                            iconPath: items[i].iconPath,
                            isActive: currentIndex == i,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            items[i].label,
                            textAlign: TextAlign.center,
                            style: TextUtils.paragraphSmallBold(
                              context,
                              color: currentIndex == i
                                  ? scheme.primaryContainer
                                  : scheme.onTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
