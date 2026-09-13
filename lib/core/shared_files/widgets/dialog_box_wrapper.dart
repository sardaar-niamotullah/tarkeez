import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class DialogBoxWrapper extends StatelessWidget {
  final String title, iconPath;
  final Widget content;
  final Color? iconColor;

  const DialogBoxWrapper({
    super.key,
    required this.title,
    required this.iconPath,
    required this.content,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      backgroundColor: scheme.surface,
      child: Padding(
        padding: const .all(16),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            // ──────────────────────────────────────────────
            // Icon, title, and close button
            // ──────────────────────────────────────────────
            Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  colorFilter: .mode(iconColor ?? scheme.primary, .srcIn),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextUtils.title2(context, color: scheme.onTertiary),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => context.pop(),
                  customBorder: const CircleBorder(),
                  child: Icon(
                    Icons.close_rounded,
                    size: 24,
                    color: scheme.onTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ──────────────────────────────────────────────
            // Content
            // ──────────────────────────────────────────────
            content,
          ],
        ),
      ),
    );
  }
}
