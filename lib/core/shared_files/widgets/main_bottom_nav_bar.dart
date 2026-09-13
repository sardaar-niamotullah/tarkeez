import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/cubits/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/bottom_nav_bar_icon.dart';

class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final scheme = Theme.of(context).colorScheme;
    final currentIndex = context.watch<NavigationCubit>().currentIndex;

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: InkRipple.splashFactory,
        splashColor: scheme.primary.withValues(alpha: .01),
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        // ────────────────────────────────────────────────────────────
        // Navigation logic
        // ────────────────────────────────────────────────────────────
        currentIndex: currentIndex,
        onTap: (index) => context.read<NavigationCubit>().navigateTo(
          NavigationTab.values[index],
        ),
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
            label: texts.home,
          ),
    
          // ────────────────────────────────────────────────────────────
          // Customers tab
          // ────────────────────────────────────────────────────────────
          BottomNavigationBarItem(
            icon: BottomNavBarIcon(
              iconPath: SvgPaths.pieChart,
              isActive: currentIndex == 1,
            ),
            label: texts.report,
          ),
    
          // ────────────────────────────────────────────────────────────
          // Stock tab
          // ────────────────────────────────────────────────────────────
          BottomNavigationBarItem(
            icon: BottomNavBarIcon(
              iconPath: SvgPaths.rank,
              isActive: currentIndex == 2,
            ),
            label: texts.leaderboard,
          ),
    
          // ────────────────────────────────────────────────────────────
          // Open drawer menu button
          // ────────────────────────────────────────────────────────────
          BottomNavigationBarItem(
            icon: BottomNavBarIcon(
              iconPath: SvgPaths.user,
              isActive: currentIndex == 3,
              size: 26,
            ),
            label: texts.profile,
          ),
        ],
      ),
    );
  }
}
