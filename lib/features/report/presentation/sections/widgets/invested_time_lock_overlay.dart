import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/widgets/section_lock_overlay.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/invested_time_stat_group.dart';

class InvestedTimeLockOverlay extends StatelessWidget {
  const InvestedTimeLockOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: InvestedTimeStatGroup(
                emoji: '️☀️',
                accentColor: AppTheme.trophyGold,
                topLabel: 'Today',
                topSeconds: 12345,
                bottomLabel: 'Yesterday',
                bottomSeconds: 12345,
              ),
            ),
            const SizedBox(width: ContainerDesignUtils.halfPadding),
            Expanded(
              child: InvestedTimeStatGroup(
                emoji: '📅',
                accentColor: AppTheme.crimsonTab,
                topLabel: 'This week',
                topSeconds: 12345,
                bottomLabel: 'Last week',
                bottomSeconds: 12345,
              ),
            ),
            const SizedBox(width: ContainerDesignUtils.halfPadding),
            Expanded(
              child: InvestedTimeStatGroup(
                emoji: '🗓️',
                accentColor: AppTheme.blue,
                topLabel: 'This month',
                topSeconds: 12345,
                bottomLabel: 'Last month',
                bottomSeconds: 12345,
              ),
            ),
          ],
        ),

        //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
        // Frosted lock banner
        //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
        Positioned.fill(
          child: SectionLockOverlay(lockedTopicName: 'invested times'),
        ),
      ],
    );
  }
}
