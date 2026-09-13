import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';

class BkashPaymentButton extends StatelessWidget {
  final String title;
  final Color backgroundColorLeft, backgroundColorRight;

  const BkashPaymentButton({
    super.key,
    required this.title,
    required this.backgroundColorLeft,
    required this.backgroundColorRight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            title: title,
            onPressed: () {},
            backgroundColorLeft: backgroundColorLeft,
            backgroundColorRight: backgroundColorRight,
          ),
        ),
        SvgPicture.asset(SvgPaths.bkash, height: 100, width: 100),
      ],
    );
  }
}
