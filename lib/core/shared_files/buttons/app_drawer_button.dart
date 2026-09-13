import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class AppDrawerButton extends StatelessWidget {
  final VoidCallback onTap;
  const AppDrawerButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: .opaque,
      onPointerUp: (_) => onTap(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: .circular(4),
          child: Row(
            children: [
              SvgPicture.asset(
                SvgPaths.hamburger,
                height: 26,
                colorFilter: .mode(AppTheme.white, .srcIn),
              ),
              const SizedBox(width: 4),
              Text(
                AppTexts.of(context).appTitle,
                style: TextUtils.title1Normal(context, color: AppTheme.white),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
