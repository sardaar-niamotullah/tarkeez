import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class AppDrawerButton extends StatelessWidget {
  const new({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: .opaque,
      onPointerUp: (_) {
        if (!context.md) onTap();
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: .circular(4),
          child: Row(
            mainAxisSize: .min,
            crossAxisAlignment: .center,
            children: [
              if (!context.md) ...[
                SvgPicture.asset(
                  height: 26,
                  SvgPaths.hamburger,
                  colorFilter: .mode(AppTheme.white, .srcIn),
                ),
                const SizedBox(width: 4),
              ],
              Text(
                'Tarkeez',
                style: TextUtils.title1Normal(context, color: AppTheme.white),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
