import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class LogoWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: .none,
      children: [
        Center(child: SvgPicture.asset(SvgPaths.logoOriginal, height: 128)),
        Positioned(
          left: 0,
          right: 0,
          bottom: -36,
          child: Text(
            'Tarkeez',
            style: TextUtils.title1(
              context,
              color: AppTheme.white,
            ).copyWith(fontSize: 34),
            textAlign: .center,
          ),
        ),
      ],
    );
  }
}
