import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/subscription/presentation/sections/widgets/perk_tile.dart';

class PremiumPerksSection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SliverPadding(
      padding: const .symmetric(vertical: 16),
      sliver: SliverList.list(
        children: [

          Text(
            'Your premium membership unlocks these exclusive features',
            style: TextUtils.paragraph(context, color: scheme.onTertiary),
          ),
          const SizedBox(height: 16),
          PerkTile(
            title: 'Unlimited projects',
            subTitle: 'Break past the 2-project limit and manage everything at once, freely.',
            iconPath: SvgPaths.projects,
            iconColor: scheme.primary,
          ),
          PerkTile(
            title: 'Advanced insights',
            subTitle: 'Unlock heatmaps, personal bests, invested times and other advanced insights',
            iconPath: SvgPaths.graphUp,
            iconColor: scheme.primary,
          ),
          PerkTile(
            title: 'Extended date filters',
            subTitle: 'Unlock more ranges in report filter, from last month to all time.',
            iconPath: SvgPaths.filter,
            iconColor: scheme.primary,
          ),
          PerkTile(
            title: 'Theme colors',
            subTitle: 'Personalize your app with a curated set of premium color themes.',
            iconPath: SvgPaths.colorPalette,
            iconColor: scheme.primary,
          ),
          PerkTile(
            title: 'Fresh start anytime',
            subTitle: 'Clear all your data and start fresh, your premium status stays intact.',
            iconPath: SvgPaths.delete,
            iconColor: scheme.primary,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
