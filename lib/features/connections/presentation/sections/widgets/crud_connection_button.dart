import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/custom_icon_button.dart';
import 'package:tarkeez/core/theme/theme.dart';

enum CrudConnectionType {
  sendRequest,
  withdrawRequest,
  cancelRequest,
  disconnectUser,
  acceptRequest,
}

class CrudConnectionButton extends StatelessWidget {
  final CrudConnectionType type;
  final VoidCallback onTap;

  const CrudConnectionButton({
    super.key,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (icon, color) = switch (type) {
      CrudConnectionType.sendRequest => (SvgPaths.userPlus, scheme.primary),
      CrudConnectionType.acceptRequest => (SvgPaths.userCheck, scheme.primary),
      CrudConnectionType.withdrawRequest => (
        SvgPaths.userMinus,
        AppTheme.warning,
      ),
      CrudConnectionType.cancelRequest => (
        SvgPaths.userCross,
        AppTheme.warning,
      ),
      CrudConnectionType.disconnectUser => (SvgPaths.brokenLink, scheme.error),
    };

    return CustomIconButton(
      onTap: onTap,
      iconSize: 18,
      iconColor: color,
      iconPath: icon,
      backgroundColor: color.withValues(alpha: .1),
    );
  }
}
