import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/routes/route_names.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class VersionAndTermsTile extends StatefulWidget {
  const new({super.key});

  @override
  State<VersionAndTermsTile> createState() => _VersionAndTermsTileState();
}

class _VersionAndTermsTileState extends State<VersionAndTermsTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: CupertinoButton(
            onPressed: () => context.push(RouteNames.termsAndConditionsPage),
            padding: .zero,
            sizeStyle: .small,
            alignment: .centerLeft,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              style: TextUtils.paragraphSmallBold(
                context,
                color: _isHovered
                    ? scheme.onTertiary
                    : scheme.onTertiary.withValues(alpha: .5),
              ),
              child: const Text('Terms and conditions'),
            ),
          ),
        ),
        Text(
          'v1.0.0',
          style: TextUtils.paragraphSmallBold(
            context,
            color: scheme.onTertiary.withValues(alpha: .5),
          ),
        ),
      ],
    );
  }
}
