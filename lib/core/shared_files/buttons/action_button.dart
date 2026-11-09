import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActionButton extends StatefulWidget {
  const new({
    super.key,
    required this.iconPath,
    required this.onTap,
    this.iconSize = 18,
    this.boxSize = 32,
    this.iconColor,
    this.backgroundColor,
    this.hoverIconColor,
    this.hoverBackgroundColor,
  });

  final String iconPath;
  final double iconSize, boxSize;
  final Color? iconColor, backgroundColor;
  final Color? hoverIconColor, hoverBackgroundColor;
  final VoidCallback onTap;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final defaultIconColor =
        widget.iconColor ?? scheme.onTertiary.withValues(alpha: 0.9);

    final defaultBackgroundColor = widget.backgroundColor ?? scheme.tertiary;

    final targetIconColor = _isHovered
        ? widget.hoverIconColor ?? defaultIconColor
        : defaultIconColor;

    final targetBackgroundColor = _isHovered
        ? widget.hoverBackgroundColor ?? defaultBackgroundColor
        : defaultBackgroundColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          customBorder: const CircleBorder(),
          mouseCursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: widget.boxSize,
            width: widget.boxSize,
            decoration: BoxDecoration(
              color: targetBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: TweenAnimationBuilder<Color?>(
                tween: ColorTween(end: targetIconColor),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                builder: (context, color, child) {
                  return SvgPicture.asset(
                    widget.iconPath,
                    height: widget.iconSize,
                    width: widget.iconSize,
                    colorFilter: ColorFilter.mode(
                      color ?? targetIconColor,
                      BlendMode.srcIn,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
