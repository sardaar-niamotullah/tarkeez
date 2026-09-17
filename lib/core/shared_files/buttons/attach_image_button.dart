import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class AttachImageButton extends StatelessWidget {
  final double width;
  final double verticalPadding;
  final bool canAttach;

  const AttachImageButton({
    super.key,
    this.width = 110,
    this.verticalPadding = 8,
    this.canAttach = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (!canAttach) {
            showWarningSnackBar(
              context,
              message: 'You can attach up to 3 images.',
            );
          }
        },
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          width: width,
          padding: .symmetric(horizontal: 16, vertical: verticalPadding),
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Row(
            mainAxisAlignment: .center,
            children: [
              SvgPicture.asset(
                SvgPaths.pictureAdd,
                height: 18,
                colorFilter: .mode(
                  scheme.onTertiary.withValues(alpha: .75),
                  .srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Image',
                style: TextUtils.paragraph(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
