import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/cubits/tracking_settings_cubit.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

extension TrackingModeLabel on TrackingMode {
  String label(String texts) {
    switch (this) {
      case TrackingMode.linear:
        return 'Linear';
      case TrackingMode.pomodoro:
        return 'Pomodoro';
    }
  }
}

class TrackingModeSwitchButton extends StatelessWidget {
  const new({super.key, required this.value, required this.onChanged});

  final TrackingMode value;
  final ValueChanged<TrackingMode> onChanged;

  static const List<TrackingMode> _options = TrackingMode.values;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selectedIndex = _options.indexOf(value);
    final count = _options.length;

    return SizedBox(
      width: 180,
      child: Container(
        decoration: BoxDecoration(
          color: scheme.onSurface,
          borderRadius: ContainerDesignUtils.allRadius,
        ),
        padding: const .symmetric(horizontal: 8, vertical: 3),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final segmentWidth = constraints.maxWidth / count;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  left: segmentWidth * selectedIndex,
                  top: 0,
                  bottom: 0,
                  width: segmentWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: scheme.surface.withValues(alpha: 1),
                      borderRadius: ContainerDesignUtils.allRadius,
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (final option in _options)
                      Expanded(
                        child: GestureDetector(
                          behavior: .opaque,
                          onTap: () => onChanged(option),
                          child: _Label(
                            context: context,
                            text: option.label('Linear'),
                            active: option == value,
                            activeColor: scheme.primary,
                            inactiveColor: scheme.onTertiary.withValues(
                              alpha: .9,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const new({
    required this.text,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
    required this.context,
  });
  
  final String text;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    final targetColor = active ? activeColor : inactiveColor;

    return Padding(
      padding: const .symmetric(vertical: 5, horizontal: 12),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 150),
        style: TextUtils.paragraphSmallBold(context, color: targetColor),
        child: Text(text, textAlign: .center, overflow: .ellipsis),
      ),
    );
  }
}
