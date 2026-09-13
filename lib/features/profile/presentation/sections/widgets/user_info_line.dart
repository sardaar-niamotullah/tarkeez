import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class UserInfoLine extends StatelessWidget {
  final String title, iconPath;
  final VoidCallback? onTap;
  const UserInfoLine({
    super.key,
    required this.title,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: ContainerDesignUtils.allRadius,
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                height: 16,
                width: 16,
                colorFilter: .mode(
                  Theme.of(
                    context,
                  ).colorScheme.onTertiary.withValues(alpha: 0.8),
                  .srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextUtils.paragraph(
                    context,
                    color: onTap != null
                        ? Theme.of(context).colorScheme.primaryFixed
                        : null,
                  ).copyWith(fontWeight: onTap != null ? .w600 : null),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
