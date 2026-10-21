import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/widgets/dialog_box_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class DeleteDialog extends StatelessWidget {
  final VoidCallback onDeleteTap;
  final bool isLoading;
  final String? message;
  const DeleteDialog({
    super.key,
    required this.onDeleteTap,
    this.isLoading = false,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DialogBoxWrapper(
      title: 'Warning',
      iconPath: SvgPaths.exclamation,
      iconColor: AppTheme.warning,
      content: Column(
        children: [
          // ──────────────────────────────────────────────
          // Message
          // ──────────────────────────────────────────────
          Text(
            message ??
                'You are about to do a destrutive opperation. Which can not be reverted. Please be sure before doing this kind of opperation.',
            style: TextUtils.paragraph(context),
            // textAlign: .center,
          ),
          const SizedBox(height: 16),

          // ──────────────────────────────────────────────
          // Action button
          // ──────────────────────────────────────────────
          Row(
            children: [
              CancelButton(isCupertinoVersion: true),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  title: 'Delete',
                  isLoading: isLoading,
                  backgroundColorLeft: AppTheme.errorBright,
                  backgroundColorRight: scheme.error,
                  onPressed: () => onDeleteTap(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
