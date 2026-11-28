import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportedPlatfromsSection extends StatelessWidget {
  const new({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SliverPadding(
      padding: .only(top: context.md ? 24 : 0, bottom: 8),
      sliver: SliverList.list(
        children: [
          Text(
            'For your convenience, Tarkeez is available on diffrent platforms, ',
            style: TextUtils.paragraph(context, color: scheme.onTertiary),
          ),
          Text(
            'Your focus, synced across all your devices',
            style: TextUtils.paragraphSmall(
              context,
              color: scheme.onTertiary.withValues(alpha: .5),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            padding: .zero,
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 30,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _platformChip(
                context,
                title: 'Android',
                link: 'https://play.google.com/store/apps/details?id=dev.sardaar.tarkeez',
                color: color,
                icon: Icons.android,
              ),
              _platformChip(
                context,
                title: 'iOS',
                link: '',
                color: color,
                icon: Icons.apple,
              ),
              _platformChip(
                context,
                title: 'macOS',
                link: '',
                color: color,
                icon: Icons.laptop_mac,
              ),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _platformChip(
    BuildContext context, {
    required String title,
    required String link,
    required Color color,
    required IconData icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await launchUrl(Uri.parse(link), mode: .externalApplication);
        },
        mouseCursor: SystemMouseCursors.click,
        borderRadius: ContainerDesignUtils.allRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: color.withValues(alpha: .75),
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
                const SizedBox(width: 4),
                Text(title, style: TextUtils.paragraphBold(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
