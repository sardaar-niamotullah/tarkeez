import 'package:tarkeez/core/shared_files/buttons/app_drawer_button.dart';
import 'package:tarkeez/core/shared_files/buttons/go_premium_button.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/primary_page_margin.dart';
import 'package:tarkeez/features/home/presentation/sections/home_last_three_days_bar_chart.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/time_log_index_tile.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/time_log_tile.dart';
import 'package:tarkeez/features/sessions/presentation/session_log_interface.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onMenuTap;
  const HomeTab({super.key, required this.onMenuTap});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        // ──────────────────────────────────────────────
        // Home App Bar bg layer
        // ──────────────────────────────────────────────
        const Positioned.fill(child: HeroImageBackgroundLayer()),
        Column(
          children: [
            // ──────────────────────────────────────────────
            // Home App Bar
            // ──────────────────────────────────────────────
            SafeArea(
              child: Container(
                height: 48,
                padding: const .only(right: 16, left: 12),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [AppDrawerButton(onTap: onMenuTap)],
                ),
              ),
            ),
            // ──────────────────────────────────────────────
            // Homepage content
            // ──────────────────────────────────────────────
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: scheme.onSurface,
                        borderRadius: ContainerDesignUtils.topRadius,
                      ),
                      child: Column(
                        children: [
                          const SessionLogInterface(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: PrimaryPageMargin(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 24),
                                    const HomeLastThreeDaysBarChart(),
                                    const SizedBox(height: 24),
                                    const TimeLogIndexTile(),
                                    const SizedBox(height: 8),
                                    const TimeLogTile(isActive: true),
                                    const TimeLogTile(),
                                  ],
                                ),
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
          ],
        ),
        const Positioned(bottom: 16, right: 16, child: GoPremiumButton()),
        // Positioned(
        //   bottom: 16,
        //   left: 16,
        //   child: FilledButton(
        //     onPressed: () {
        //       AppClock.fakeCurrentTime(
        //         DateTime(2026, 9, 12, 03, 00),
        //         speed: 60,
        //       );
        //       showSuccessSnackBar(context, message: '🕰️ fake time started');
        //       Timer.periodic(const Duration(seconds: 1), (_) {
        //         debugPrint(
        //           '🕰️ fake clock: ${DateFormatter.readableDateTime(AppClock.now())}',
        //         );
        //       });
        //     },
        //     child: Icon(Icons.timer_rounded),
        //   ),
        // ),
        // Positioned(
        //   bottom: 16,
        //   left: 100,
        //   child: FilledButton(
        //     onPressed: () {
        //       AppClock.reset();
        //       showSuccessSnackBar(context, message: '🕰️ fake time reset');
        //     },
        //     child: Icon(Icons.block_rounded),
        //   ),
        // ),
      ],
    );
  }
}
