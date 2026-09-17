import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
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
    return Material(
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
    );
  }
}
