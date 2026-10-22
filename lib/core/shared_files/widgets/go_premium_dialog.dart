import 'package:flutter/cupertino.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/go_premium_button.dart';
import 'package:tarkeez/core/shared_files/widgets/dialog_box_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class GoPremiumDialog extends StatelessWidget {
  const GoPremiumDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return DialogBoxWrapper(
      title: '',
      iconPath: SvgPaths.medal,
      iconColor: AppTheme.fireTone,
      content: Column(
        children: [
          // ──────────────────────────────────────────────
          // Message
          // ──────────────────────────────────────────────
          Text(
            'Unlock this and all other Premium features to get the most out of your Tarkeez experience.\n\n'
            'Upgrade to Premium today and take your productivity to the next level.',
            style: TextUtils.paragraph(context),
          ),
          const SizedBox(height: 16),

          // ──────────────────────────────────────────────
          // Action button
          // ──────────────────────────────────────────────
          const Row(
            children: [
              CancelButton(isCupertinoVersion: true),
              SizedBox(width: 16),
              Expanded(child: GoPremiumButton()),
            ],
          ),
        ],
      ),
    );
  }
}
