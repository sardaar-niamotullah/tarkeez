import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/buttons/action_button.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinks extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        ActionButton(
          iconPath: SvgPaths.instagram,
          hoverIconColor: scheme.tertiary,
          hoverBackgroundColor: scheme.onTertiary,
          onTap: () async {
            await launchUrl(
              Uri.parse('https://www.instagram.com/tarkeez247/'),
              mode: .externalApplication,
            );
          },
        ),
        ActionButton(
          iconPath: SvgPaths.x,
          hoverIconColor: scheme.tertiary,
          hoverBackgroundColor: scheme.onTertiary,
          onTap: () async {
            await launchUrl(
              Uri.parse('https://x.com/tarkeez247'),
              mode: .externalApplication,
            );
          },
        ),
        ActionButton(
          iconPath: SvgPaths.linkedin,
          hoverIconColor: scheme.tertiary,
          hoverBackgroundColor: scheme.onTertiary,
          onTap: () async {
            await launchUrl(
              Uri.parse('https://www.linkedin.com/company/tarkeeez/'),
              mode: .externalApplication,
            );
          },
        ),
        ActionButton(
          iconPath: SvgPaths.facebook,
          hoverIconColor: scheme.tertiary,
          hoverBackgroundColor: scheme.onTertiary,
          onTap: () async {
            await launchUrl(
              Uri.parse(
                'https://www.facebook.com/profile.php?id=61596176576164',
              ),
              mode: .externalApplication,
            );
          },
        ),
      ],
    );
  }
}
