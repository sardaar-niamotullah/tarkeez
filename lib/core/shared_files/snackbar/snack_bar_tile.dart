import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class SnackBarTile extends StatelessWidget {
  final String? title;
  final String message;
  final String iconPath;
  final Color backgoundColor;
  final Color backgoundColorBright;
  final ColorScheme scheme;
  final VoidCallback onClose;
  final Color textColor;
  final Color iconColor;

  const SnackBarTile({
    super.key,
    this.title,
    required this.message,
    required this.iconPath,
    required this.backgoundColor,
    required this.backgoundColorBright,
    required this.scheme,
    required this.onClose,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .only(left: 16, top: 12, bottom: 14, right: 16),
      decoration: BoxDecoration(
        borderRadius: ContainerDesignUtils.allRadius,
        gradient: LinearGradient(
          colors: [backgoundColorBright, backgoundColor],
        ),
      ),
      child: Row(
        children: [
          // ── Leading icon ───────────────────────────────────────────
          SvgPicture.asset(iconPath, colorFilter: .mode(iconColor, .srcIn)),
          const SizedBox(width: 12),
          // ── Title and Subtitle ───────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextUtils.paragraphBold(context, color: textColor),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: TextUtils.paragraph(
                    context,
                    color: textColor,
                  ).copyWith(height: 1.1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // ── Close button ───────────────────────────────────────────
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClose,
              customBorder: const CircleBorder(),
              child: Icon(Icons.close, color: textColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
