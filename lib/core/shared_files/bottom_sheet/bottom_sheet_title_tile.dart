import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomSheetTitleTile extends StatelessWidget {
    const new({
    super.key,
    required this.title,
    required this.iconPath,
    this.iconSize = 24,
  });
  final String title, iconPath;
  final double iconSize;



  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          height: iconSize,
          width: iconSize,
          colorFilter: .mode(scheme.primary, .srcIn),
        ),
        const SizedBox(width: 8),
        Text(title, style: TextUtils.title2(context, color: scheme.primary)),
      ],
    );
  }
}
