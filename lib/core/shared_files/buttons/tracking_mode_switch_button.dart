import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/enums/user_preference_enums.dart';
import 'package:tarkeez/core/shared_files/widgets/go_premium_dialog.dart';
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
    final count = _options.length;
    final scheme = Theme.of(context).colorScheme;
    final selectedIndex = _options.indexOf(value);

    return SizedBox(
      width: 208,
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
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (option.isPremium) {
                                showDialog<void>(
                                  context: context,
                                  builder: (_) => const GoPremiumDialog(),
                                );
                                return;
                              }

                              onChanged(option);
                            },
                            child: _Label(
                              context: context,
                              text: option.label('Linear'),
                              active: option == value,
                              isLocked: option.isPremium,
                              activeColor: scheme.primary,
                              inactiveColor: scheme.onTertiary.withValues(
                                alpha: .9,
                              ),
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
    required this.isLocked,
  });

  final String text;
  final bool active, isLocked;
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
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Text(text, textAlign: .center, overflow: .ellipsis),
            if (isLocked) ...[
              const SizedBox(width: 6),
              Transform.translate(
                offset: Offset(0, -1),
                child: SvgPicture.asset(
                  height: 10,
                  width: 10,
                  SvgPaths.lock,
                  colorFilter: .mode(
                    Theme.of(context).colorScheme.onTertiary,
                    .srcIn,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
