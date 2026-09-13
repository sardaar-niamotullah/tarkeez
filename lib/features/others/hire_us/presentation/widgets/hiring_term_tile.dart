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
      decoration: BoxDecoration(borderRadius: ContainerDesignUtils.allRadius),
      child: ListTile(
        dense: false,
        leading: isPricingCard
            ? CircleAvatar(
                radius: 16,
                backgroundColor: scheme.surface,
                child: SvgPicture.asset(
                  SvgPaths.taka,
                  colorFilter: .mode(scheme.primary, .srcIn),
                ),
              )
            : SvgPicture.asset(
                SvgPaths.stop,
                colorFilter: .mode(scheme.error, .srcIn),
              ),
        title: Text(
          title,
          style: TextUtils.paragraphBold(context, color: scheme.onTertiary),
        ),
        subtitle: Text(details, style: TextUtils.paragraph(context)),
      ),
    );
  }
}
