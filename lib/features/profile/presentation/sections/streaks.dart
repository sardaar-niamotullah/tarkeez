import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/streak_card.dart';

class Streaks extends StatelessWidget {
  const Streaks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('Streaks', style: TextUtils.title2(context)),
        const SizedBox(height: 8),
        //––––––––––––––––––––––––––––––––––––––––––––––––––––––
        // Streak cards
        //––––––––––––––––––––––––––––––––––––––––––––––––––––––
        Row(
          children: [
            Expanded(
              child: StreakCard(
                streak: 12,
                title: 'Current streak',
                emoji: '🔥',
              ),
            ),
            const SizedBox(width: ContainerDesignUtils.halfPadding),
            Expanded(
              child: StreakCard(
                streak: 321,
                title: 'Longest steak',
                emoji: '🏆',
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
