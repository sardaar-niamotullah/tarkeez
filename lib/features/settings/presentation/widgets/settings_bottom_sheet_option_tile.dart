import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class SettingsBottomSheetOptionTile extends StatelessWidget {
  final String title;
  final Widget action;
  final bool isLastTile;

  const SettingsBottomSheetOptionTile({
    super.key,
    required this.title,
    required this.action,
    this.isLastTile = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 55,
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const SizedBox(height: 4),
          Padding(
            padding: const .symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(title, style: TextUtils.title3Normal(context)),
                // ──────────────────────────────────────────────────────────
                // Action
                // ──────────────────────────────────────────────────────────
                action,
              ],
            ),
          ),
          const SizedBox(height: 4),
          if (!isLastTile)
            Divider(
              height: 1,
              thickness: 0.5,
              indent: 86,
              endIndent: 86,
              color: scheme.outline.withValues(alpha: .15),
            ),
        ],
      ),
    );
  }
}
