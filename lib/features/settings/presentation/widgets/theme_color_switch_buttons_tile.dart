import 'package:tarkeez/core/shared_files/buttons/theme_color_switch_button.dart';
import 'package:tarkeez/core/shared_files/cubits/user_preferences_cubit.dart';
import 'package:tarkeez/core/shared_files/enums/user_preference_enums.dart';
import 'package:tarkeez/core/shared_files/widgets/go_premium_dialog.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeColorSwitchButtonsTile extends StatelessWidget {
  const new({super.key});

  void _onThemeColorTap(BuildContext context, AppThemeColor themeColor) {
    if (themeColor.isPremium) {
      showDialog<void>(
        context: context,
        builder: (_) => const GoPremiumDialog(),
      );
      return;
    }
    context.read<UserPreferencesCubit>().setThemeColor(themeColor);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPreferencesCubit, UserPreferencesState>(
      buildWhen: (a, b) => a.themeColor != b.themeColor,
      builder: (context, preferences) {
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
                isLocked: AppThemeColor.green.isPremium,
                isActive: preferences.themeColor == AppThemeColor.green,
                onTap: () => _onThemeColorTap(context, AppThemeColor.green),
              ),
              ThemeColorSwitchButton(
                themeColor: AppTheme.purpleBright,
                isLocked: AppThemeColor.purple.isPremium,
                isActive: preferences.themeColor == AppThemeColor.purple,
                onTap: () => _onThemeColorTap(context, AppThemeColor.purple),
              ),
              ThemeColorSwitchButton(
                themeColor: AppTheme.pinkBright,
                isLocked: AppThemeColor.pink.isPremium,
                isActive: preferences.themeColor == AppThemeColor.pink,
                onTap: () => _onThemeColorTap(context, AppThemeColor.pink),
              ),
              ThemeColorSwitchButton(
                themeColor: AppTheme.blueBright,
                isLocked: AppThemeColor.blue.isPremium,
                isActive: preferences.themeColor == AppThemeColor.blue,
                onTap: () => _onThemeColorTap(context, AppThemeColor.blue),
              ),
            ],
          ),
        );
      },
    );
  }
}
