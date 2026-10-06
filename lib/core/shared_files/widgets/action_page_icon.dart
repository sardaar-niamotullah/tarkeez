import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/theme/theme.dart';

class ActionPageIcon extends StatelessWidget {
  const new({super.key, required this.iconPath, this.size = 24});
  final String iconPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      colorFilter: .mode(AppTheme.white, .srcIn),
    );
  }
}
