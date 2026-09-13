import 'package:tarkeez/core/utils/primary_page_margin.dart';
import 'package:tarkeez/features/leaderboard/presentation/sections/widgets/leaderboard_filter_title.dart';
import 'package:tarkeez/features/leaderboard/presentation/sections/widgets/own_rank_status.dart';
import 'package:tarkeez/features/leaderboard/presentation/sections/widgets/user_rank_list_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/custom_app_bar.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:flutter/material.dart';

class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        const Positioned.fill(child: HeroImageBackgroundLayer()),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ──────────────────────────────────────────────────────────
              // App bar
              // ──────────────────────────────────────────────────────────
              CustomAppBar(
                title: texts.leaderboard,
                isBackButtonEnabled: false,
                actions: [ActionPageIcon(iconPath: SvgPaths.rank)],
              ),
              Expanded(
                child: Container(
                  clipBehavior: .hardEdge,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: ContainerDesignUtils.topRadius,
                  ),
                  child: CustomScrollView(
                    slivers: [
                      //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                      // Filter
                      //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                      const LeaderboardFilterTitle(),
                      //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                      // Users ranking list
                      //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                      Skeletonizer.sliver(
                        enabled: false,
                        child: SliverList.builder(
                          itemCount: 100,
                          itemBuilder: (context, index) => PrimaryPageMargin(
                            child: UserRankListTile(rank: index + 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Positioned(bottom: 16, right: 16, child: OwnRankStatus()),
      ],
    );
  }
}
