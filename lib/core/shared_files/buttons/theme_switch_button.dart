import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.mode == ThemeMode.dark;
        final themeCubit = context.read<ThemeCubit>();

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => themeCubit.toggleTheme(),
            borderRadius: ContainerDesignUtils.allRadius,
            child: Ink(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: isDark ? scheme.onSurface : scheme.tertiary,
                borderRadius: ContainerDesignUtils.allRadius,
              ),
              child: Stack(
                alignment: .center,
                children: [
                  // Bright mode icon
                  Positioned(
                    left: 10,
                    child: Icon(
                      Icons.light_mode_outlined,
                      color: scheme.onTertiary,
                      size: 14,
                    ),
                  ),

                  // Dark mode icon
                  Positioned(
                    right: 10,
                    child: Icon(
                      Icons.dark_mode_outlined,
                      color: scheme.onTertiary,
                      size: 14,
                    ),
                  ),

                  // Sliding circle
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: isDark ? .centerRight : .centerLeft,
                    child: Container(
                      margin: const .all(4),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        shape: .circle,
                      ),
                      child: Center(
                        child: Icon(
                          isDark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          color: scheme.tertiary,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
