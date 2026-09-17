import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class HiringTermTile extends StatelessWidget {
  final String title, details;
  final bool isPricingCard;

  const HiringTermTile({
    super.key,
    required this.title,
    required this.details,
    this.isPricingCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const .only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: ContainerDesignUtils.allRadius,
        color: scheme.onSurface,
      ),
      child: ListTile(
        dense: false,
        leading: isPricingCard
            ? CircleAvatar(
                radius: 16,
                backgroundColor: scheme.surface,
                child: SvgPicture.asset(
                  SvgPaths.dollar,
                  colorFilter: .mode(scheme.primary, .srcIn),
                ),
              )
            : SvgPicture.asset(
                SvgPaths.stop,
                colorFilter: .mode(scheme.error, .srcIn),
              ),
        title: Container(
          margin: .only(bottom: 4),
          child: Text(
            title,
            style: TextUtils.paragraphBold(
              context,
              color: scheme.onTertiary.withValues(alpha: .9),
            ),
          ),
        ),
        subtitle: Text(
          details,
          style: TextUtils.paragraph(
            context,
            color: scheme.onTertiary.withValues(alpha: .7),
          ),
        ),
      ),
    );
  }
}
