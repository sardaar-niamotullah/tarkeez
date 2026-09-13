import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

enum RankAreaType { global, local, connections }

extension RankAreaTypeLabel on RankAreaType {
  String label(AppTexts texts) {
    switch (this) {
      case RankAreaType.global:
        return 'Global';
      case RankAreaType.local:
        return 'Local';
      case RankAreaType.connections:
        return 'Connections';
    }
  }
}

class RankAreaSelectionSegmentedPicker extends StatelessWidget {
  final RankAreaType value;
  final ValueChanged<RankAreaType> onChanged;

  const RankAreaSelectionSegmentedPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<RankAreaType> _options = RankAreaType.values;

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final scheme = Theme.of(context).colorScheme;
    final selectedIndex = _options.indexOf(value);
    final count = _options.length;

    return Container(
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      padding: const .symmetric(horizontal: 8, vertical: 4),
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
                          text: option.label(texts),
                          active: option == value,
                          isLocked: option.label(texts) != 'Global',
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
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final bool active;
  final bool isLocked;
  final Color activeColor;
  final Color inactiveColor;
  final BuildContext context;

  const _Label({
    required this.text,
    required this.active,
    this.isLocked = false,
    required this.activeColor,
    required this.inactiveColor,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    final targetColor = active ? activeColor : inactiveColor;

    return Padding(
      padding: const .symmetric(vertical: 6, horizontal: 12),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 150),
        style: TextUtils.paragraphSmallBold(context, color: targetColor),
        child: Row(
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            if (isLocked) ...[
              TweenAnimationBuilder<Color?>(
                tween: ColorTween(end: targetColor),
                duration: const Duration(milliseconds: 150),
                builder: (context, color, child) {
                  return Padding(
                    padding: const .only(bottom: 2),
                    child: SvgPicture.asset(
                      SvgPaths.lock,
                      height: 12,
                      width: 12,
                      colorFilter: .mode(color ?? inactiveColor, .srcIn),
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(text, textAlign: .center, overflow: .ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
