import 'package:tarkeez/core/shared_files/buttons/theme_color_switch_button.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeColorSwitchButtonsTile extends StatelessWidget {
  const ThemeColorSwitchButtonsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final cubit = context.read<ThemeCubit>();
        return Container(
          height: 30,
          width: 148,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Row(
            mainAxisAlignment: .spaceAround,
            children: [
              ThemeColorSwitchButton(
                themeColor: AppTheme.greenBright,
                isActive: themeState.color == AppThemeColor.green,
                onTap: () => cubit.setColor(AppThemeColor.green),
              ),
              ThemeColorSwitchButton(
                themeColor: AppTheme.purpleBright,
                isActive: themeState.color == AppThemeColor.purple,
                onTap: () => cubit.setColor(AppThemeColor.purple),
              ),
              ThemeColorSwitchButton(
                themeColor: AppTheme.pinkBright,
                isActive: themeState.color == AppThemeColor.pink,
                onTap: () => cubit.setColor(AppThemeColor.pink),
              ),
              ThemeColorSwitchButton(
                themeColor: AppTheme.blueBright,
                isActive: themeState.color == AppThemeColor.blue,
                onTap: () => cubit.setColor(AppThemeColor.blue),
              ),
              ThemeColorSwitchButton(
                themeColor: AppTheme.tealBright,
                isActive: themeState.color == AppThemeColor.teal,
                onTap: () => cubit.setColor(AppThemeColor.teal),
              ),
            ],
          ),
        );
      },
    );
  }
}
