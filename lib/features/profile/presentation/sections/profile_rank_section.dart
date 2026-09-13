import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/buttons/custom_dropdown_button.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/rank_card.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/streak_card.dart';

enum RankAreaRange {
  global('Global'),
  local('Local');

  const RankAreaRange(this.label);
  final String label;
}

class ProfileRankSection extends StatelessWidget {
  const ProfileRankSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text('Rank', style: TextUtils.title2(context)),
            CustomDropdownButton<RankAreaRange>(
              items: RankAreaRange.values,
              labelBuilder: (range) => range.label,
              initialValue: RankAreaRange.global,
              buttonWidth: 104,
              isLocked: (range) => range == RankAreaRange.local,
              onChanged: (range) {
                // handle selection
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        //––––––––––––––––––––––––––––––––––––––––––––––––––––––
        // Rank card
        //––––––––––––––––––––––––––––––––––––––––––––––––––––––
        Row(
          children: [
            Expanded(
              child: RankCard(
                title: 'Current month',
                place: '4,825,447',
                durationInSeconds: 12132,
                emoji: '🔥',
              ),
            ),
            const SizedBox(width: ContainerDesignUtils.halfPadding),
            Expanded(
              child: RankCard(
                title: 'Best: Jan 2026',
                place: '4,825',
                durationInSeconds: 12132,
                emoji: '🏆',
                mainAxisAlignment: .end,
                crossAxisAlignment: .end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        //––––––––––––––––––––––––––––––––––––––––––––––––––––––
        // Streak card
        //––––––––––––––––––––––––––––––––––––––––––––––––––––––
        Row(
          children: [
            Expanded(
              child: StreakCard(
                streak: 12,
                title: 'Current streak',
                emoji: '⚡️',
              ),
            ),
            const SizedBox(width: ContainerDesignUtils.halfPadding),
            Expanded(
              child: StreakCard(
                streak: 321,
                title: 'Longest steak',
                emoji: '⛓️',
                mainAxisAlignment: .end,
                crossAxisAlignment: .end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
