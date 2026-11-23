import 'package:flutter/cupertino.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/go_premium_button.dart';
import 'package:tarkeez/core/shared_files/widgets/dialog_box_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/asset_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class GoPremiumDialog extends StatelessWidget {
  const new({super.key, this.message, this.closeBottomSheet = false});

  final String? message;
  final bool closeBottomSheet;

  @override
  Widget build(BuildContext context) {
    return DialogBoxWrapper(
      title: 'Locked',
      iconPath: AssetPaths.lock,
      iconColor: AppTheme.fireTone,
      content: Column(
        children: [
          // ──────────────────────────────────────────────
          // Message
          // ──────────────────────────────────────────────
          Text(
            message ??
                'Unlock this and all other Premium features to get the most out of your Tarkeez experience.\n\n'
                    'Upgrade to Premium today and take your productivity to the next level.',
            style: TextUtils.paragraph(context),
          ),
          const SizedBox(height: 16),

          // ──────────────────────────────────────────────
          // Action button
          // ──────────────────────────────────────────────
          Row(
            children: [
              const CancelButton(isCupertinoVersion: true),
              const SizedBox(width: 16),
              Expanded(
                child: GoPremiumButton(
                  isDialogBoxButton: true,
                  closeBottomSheet: closeBottomSheet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
