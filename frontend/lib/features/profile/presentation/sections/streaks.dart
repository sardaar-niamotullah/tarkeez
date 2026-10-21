import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/streak_card.dart';

class Streaks extends StatelessWidget {
  const Streaks({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: streak isn't updating in real time, need app restart.
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('Streaks', style: TextUtils.title2(context)),
        const SizedBox(height: 8),
        //––––––––––––––––––––––––––––––––––––––––––––––––––––––
        // Streak cards
        //––––––––––––––––––––––––––––––––––––––––––––––––––––––
        BlocBuilder<DailyRollupBloc, DailyRollupState>(
          buildWhen: (previous, current) =>
              current is DailyRollupLoaded || current is DailyRollupInitial,
          builder: (context, state) {
            final currentStreak = state is DailyRollupLoaded
                ? state.currentStreak
                : 0;
            final longestStreak = state is DailyRollupLoaded
                ? state.longestStreak
                : 0;

            return GridView.count(
              shrinkWrap: true,
              crossAxisCount: context.sm ? 1 : 2,
              mainAxisExtent: 54,
              crossAxisSpacing: ContainerDesignUtils.halfPadding,
              mainAxisSpacing: ContainerDesignUtils.halfPadding,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                StreakCard(
                  streak: currentStreak,
                  title: 'Current streak',
                  emoji: '🔥',
                ),
                StreakCard(
                  streak: longestStreak,
                  title: 'Longest streak',
                  emoji: '🏆',
                  mainAxisAlignment: context.sm ? .start : .end,
                  crossAxisAlignment: context.sm ? .start : .end,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
