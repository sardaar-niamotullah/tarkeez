import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';

class PrimaryIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;
  const PrimaryIconButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          height: 43,
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              colorFilter: .mode(scheme.primary, .srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
