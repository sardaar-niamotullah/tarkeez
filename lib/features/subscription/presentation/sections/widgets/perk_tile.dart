import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class PerkTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String iconPath;
  final Color iconColor;

  const PerkTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.iconPath,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const .only(bottom: 12),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: ListTile(
        dense: true,
        leading: SvgPicture.asset(
          iconPath,
          colorFilter: .mode(scheme.primary, .srcIn),
        ),
        title: Container(
          margin: .only(bottom: 4),
          child: Text(
            title,
            style: TextUtils.paragraphBold(context, color: scheme.onTertiary),
          ),
        ),
        subtitle: Text(subTitle, style: TextUtils.paragraph(context)),
      ),
    );
  }
}
