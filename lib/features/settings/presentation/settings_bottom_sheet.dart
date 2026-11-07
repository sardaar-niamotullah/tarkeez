import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_title_tile.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:tarkeez/core/shared_files/buttons/theme_switch_button.dart';
import 'package:tarkeez/core/shared_files/buttons/tracking_mode_switch_button.dart';
import 'package:tarkeez/core/shared_files/cubits/session_timer_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/tracking_settings_cubit.dart';
import 'package:tarkeez/features/settings/presentation/widgets/settings_bottom_sheet_option_tile.dart';
import 'package:tarkeez/features/settings/presentation/widgets/theme_color_switch_buttons_tile.dart';

class SettingsBottomSheet extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.select((TrackingSettingsCubit c) => c.state.mode);

    return BottomSheetWrapper(
      contents: [
        BottomSheetTitleTile(title: 'Settings', iconPath: SvgPaths.gear),
        const SizedBox(height: 8),
        SettingsBottomSheetOptionTile(
          title: 'Theme mode',
          action: ThemeSwitchButton(),
        ),
        SettingsBottomSheetOptionTile(
          title: 'Theme color',
          action: ThemeColorSwitchButtonsTile(),
        ),
        SettingsBottomSheetOptionTile(
          title: 'Tracking mode',
          action: TrackingModeSwitchButton(
            value: mode,
            onChanged: (type) {
              // Tapping the active option must not stop a running session.
              if (type == mode) return;
              // Switching stops and saves the running session. The new mode
              // is started manually from the play button.
              context.read<SessionTimerCubit>().reset();
              context.read<TrackingSettingsCubit>().setMode(type);
            },
          ),
          isLastTile: true,
        ),
      ],
    );
  }
}
