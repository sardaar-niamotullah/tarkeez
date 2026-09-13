import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';

class CustomSwitchButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          width: 58,
          height: 28,
          decoration: BoxDecoration(
            color: value
                ? scheme.primary.withValues(alpha: .1)
                : scheme.onTertiary.withValues(alpha: .1),
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: value ? .centerRight : .centerLeft,
            child: Container(
              margin: const .all(4),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: value
                    ? scheme.primaryContainer
                    : scheme.onTertiary.withValues(alpha: .85),
                shape: .circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
