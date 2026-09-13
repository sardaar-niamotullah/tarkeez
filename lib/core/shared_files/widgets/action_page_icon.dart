import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/theme/theme.dart';

class ActionPageIcon extends StatelessWidget {
  final String iconPath;
  const ActionPageIcon({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      colorFilter: .mode(AppTheme.white, .srcIn),
    );
  }
}
