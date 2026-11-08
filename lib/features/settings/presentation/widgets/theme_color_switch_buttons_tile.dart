import 'package:tarkeez/core/shared_files/buttons/theme_color_switch_button.dart';
import 'package:tarkeez/core/shared_files/cubits/user_preferences_cubit.dart';
import 'package:tarkeez/core/shared_files/enums/user_settings_enums.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeColorSwitchButtonsTile extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPreferencesCubit, UserPreferencesState>(
      buildWhen: (a, b) => a.themeColor != b.themeColor,
      builder: (context, preferences) {
        final cubit = context.read<UserPreferencesCubit>();
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
                isActive: preferences.themeColor == AppThemeColor.green,
                onTap: () => cubit.setThemeColor(AppThemeColor.green),
              ),
              ThemeColorSwitchButton(
                themeColor: AppTheme.purpleBright,
                isActive: preferences.themeColor == AppThemeColor.purple,
                onTap: () => cubit.setThemeColor(AppThemeColor.purple),
              ),
              ThemeColorSwitchButton(
                themeColor: AppTheme.pinkBright,
                isActive: preferences.themeColor == AppThemeColor.pink,
                onTap: () => cubit.setThemeColor(AppThemeColor.pink),
              ),
              ThemeColorSwitchButton(
                themeColor: AppTheme.blueBright,
                isActive: preferences.themeColor == AppThemeColor.blue,
                onTap: () => cubit.setThemeColor(AppThemeColor.blue),
              ),
              ThemeColorSwitchButton(
                themeColor: AppTheme.tealBright,
                isActive: preferences.themeColor == AppThemeColor.teal,
                onTap: () => cubit.setThemeColor(AppThemeColor.teal),
              ),
            ],
          ),
        );
      },
    );
  }
}
