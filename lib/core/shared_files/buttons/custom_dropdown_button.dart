import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/widgets/go_premium_dialog.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class CustomDropdownButton<T> extends StatefulWidget {
  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.labelBuilder,
    required this.initialValue,
    required this.buttonWidth,
    this.onChanged,
    this.itemHeight = 28,
    this.isLocked,
    this.buttonColor,
  });

  final List<T> items;
  final String Function(T value) labelBuilder;
  final T initialValue;
  final double buttonWidth;
  final ValueChanged<T>? onChanged;
  final double itemHeight;
  final bool Function(T value)? isLocked;
  final Color? buttonColor;

  @override
  State<CustomDropdownButton<T>> createState() =>
      _CustomDropdownButtonState<T>();
}

class _CustomDropdownButtonState<T> extends State<CustomDropdownButton<T>> {
  static const Duration _menuAnimationDuration = Duration(milliseconds: 300);

  late T _selected = widget.initialValue;
  bool _isOpen = false;

  Future<void> _openMenu(BuildContext context, Offset position) async {
    final scheme = Theme.of(context).colorScheme;

    setState(() => _isOpen = true);

    final selected = await showMenu<T>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      color: widget.buttonColor ?? scheme.onSurface,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: ContainerDesignUtils.bottomRadius,
      ),
      constraints: BoxConstraints(
        minWidth: widget.buttonWidth,
        maxWidth: widget.buttonWidth,
      ),
      items: widget.items.where((item) => item != _selected).map((item) {
        final locked = widget.isLocked?.call(item) ?? false;
        return PopupMenuItem<T>(
          value: item,
          height: widget.itemHeight,
          padding: const .symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                widget.labelBuilder(item),
                style: TextUtils.paragraph(context),
              ),
              if (locked)
                SvgPicture.asset(
                  SvgPaths.lock,
                  height: 16,
                  colorFilter: .mode(
                    scheme.onTertiary.withValues(alpha: .8),
                    .srcIn,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
    await Future.delayed(_menuAnimationDuration);
    if (mounted) setState(() => _isOpen = false);

    if (selected != null && selected != _selected) {
      if (widget.isLocked?.call(selected) ?? false) {
        if (!context.mounted) return;
        showDialog(context: context, builder: (_) => const GoPremiumDialog());
      } else {
        setState(() => _selected = selected);
        widget.onChanged?.call(selected);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final buttonRadius = _isOpen
        ? ContainerDesignUtils.topRadius
        : ContainerDesignUtils.allRadius;

    return Material(
      color: Colors.transparent,
      child: Builder(
        builder: (buttonContext) {
          return InkWell(
            onTap: () {
              final box = buttonContext.findRenderObject() as RenderBox;
              final position = box.localToGlobal(Offset(0, box.size.height));
              _openMenu(context, position);
            },
            borderRadius: buttonRadius,
            child: Ink(
              width: widget.buttonWidth,
              padding: const .only(left: 16, right: 12),
              decoration: BoxDecoration(
                color: widget.buttonColor ?? scheme.onSurface,
                borderRadius: buttonRadius,
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    widget.labelBuilder(_selected),
                    style: TextUtils.title3Normal(context),
                  ),
                  SvgPicture.asset(
                    SvgPaths.arrowDown,
                    colorFilter: .mode(
                      scheme.onTertiary.withValues(alpha: .8),
                      .srcIn,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
