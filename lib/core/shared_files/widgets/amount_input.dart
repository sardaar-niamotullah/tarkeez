import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/primary_page_margin.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class AmountInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? errorText;
  final bool autofocus;

  const AmountInput({
    super.key,
    this.onChanged,
    this.controller,
    this.errorText,
    this.autofocus = true,
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final borderColor = widget.errorText != null
        ? scheme.error
        : _isFocused
        ? scheme.primary.withValues(alpha: .75)
        : Colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: .all(PrimaryPageMargin.margin),
            decoration: BoxDecoration(
              color: scheme.onSurface,
              borderRadius: ContainerDesignUtils.allRadius,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: .center,
              children: [
                SvgPicture.asset(
                  SvgPaths.taka,
                  height: 36,
                  colorFilter: .mode(
                    scheme.onTertiary.withValues(alpha: .8),
                    .srcIn,
                  ),
                ),
                IntrinsicWidth(
                  child: TextField(
                    cursorWidth: 2,
                    cursorHeight: 44,
                    textAlign: .center,
                    focusNode: _focusNode,
                    autofocus: widget.autofocus,
                    onChanged: widget.onChanged,
                    cursorColor: scheme.primary,
                    controller: widget.controller,
                    style: TextUtils.title1(context).copyWith(fontSize: 48),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                      LengthLimitingTextInputFormatter(12),
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const .only(top: 6, left: 8),
          child: Text(
            widget.errorText ?? '',
            style: TextUtils.paragraphSmall(context, color: scheme.error),
          ),
        ),
      ],
    );
  }
}
