import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class CancelButton extends StatelessWidget {
  final bool enable;
  final VoidCallback? onPressed;
  final bool isCupertinoVersion;
  const CancelButton({
    super.key,
    this.enable = true,
    this.onPressed,
    this.isCupertinoVersion = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return !isCupertinoVersion
        ? PrimaryButton(
            title: AppTexts.of(context).cancel,
            textColor: scheme.primary,
            backgroundColorLeft: scheme.onSurface,
            backgroundColorRight: scheme.onSurface,
            enable: enable,
            onPressed: onPressed ?? () => context.pop(),
          )
        : CupertinoButton(
            onPressed: onPressed ?? () => context.pop(),
            child: Text(
              'Cancel',
              style: TextUtils.title3(context, color: scheme.primary),
            ),
          );
  }
}
