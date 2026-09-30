import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/date_time_formatter.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/set_pomodoro_duration_bottom_sheet.dart';

class PomodoroSetDurationButton extends StatefulWidget {
  const PomodoroSetDurationButton({super.key, this.isPomodoroModeOn = false});
  final bool isPomodoroModeOn;

  @override
  State<PomodoroSetDurationButton> createState() =>
      _PomodoroSetDurationButtonState();
}

class _PomodoroSetDurationButtonState extends State<PomodoroSetDurationButton> {
  int currentDuration = 25;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: .center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: !widget.isPomodoroModeOn
                ? null
                : () => showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => SetPomodoroDurationBottomSheet(
                      initialMinutes: currentDuration,
                      onDurationPicked: (minutes) => setState(() {
                        currentDuration = minutes;
                      }),
                    ),
                  ),
            borderRadius: ContainerDesignUtils.allRadius,
            child: Ink(
              padding: .symmetric(
                horizontal: ContainerDesignUtils.padding,
                vertical: ContainerDesignUtils.quarterPadding,
              ),
              decoration: BoxDecoration(
                color: scheme.onSurface,
                borderRadius: ContainerDesignUtils.allRadius,
              ),
              child: Text(
                widget.isPomodoroModeOn ? 'Set duration' : 'Today',
                style: TextUtils.paragraphSmallBold(context),
              ),
            ),
          ),
        ),

        if (widget.isPomodoroModeOn) ...[
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final durationText = DateTimeFormatter.formatDurationSeconds(
                  1232,
                );
                showInfoSnackBar(
                  context,
                  iconPath: SvgPaths.exclamation,
                  message: durationText,
                );
              },
              borderRadius: ContainerDesignUtils.allRadius,
              child: Ink(
                padding: .symmetric(
                  horizontal: ContainerDesignUtils.padding,
                  vertical: ContainerDesignUtils.quarterPadding,
                ),
                decoration: BoxDecoration(
                  color: scheme.onSurface,
                  borderRadius: ContainerDesignUtils.allRadius,
                ),
                child: DurationTextUtils(
                  durationInSeconds: 0,
                  fontSizePrimary: 12,
                  fontSizeSeconday: 10,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
