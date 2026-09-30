import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/utils/date_time_formatter.dart';

class HeatmapPoint extends StatelessWidget {
  final int seconds;
  final DateTime? date;
  final bool paintHeatmap;

  const HeatmapPoint({
    super.key,
    required this.seconds,
    this.date,
    this.paintHeatmap = true,
  });

  double getOpacity(num seconds) {
    final s = seconds.toDouble();
    const thirtyMin = 30 * 60;
    const fiveHours = 5 * 60 * 60;
    const tenHours = 10 * 60 * 60;

    if (s < thirtyMin) {
      return 0.0; // 0 – 29 min
    } else if (s <= fiveHours) {
      // 30 min → 5 h : 0.2 → 0.8
      return 0.2 + ((s - thirtyMin) / (fiveHours - thirtyMin)) * (0.8 - 0.2);
    } else if (s <= tenHours) {
      // 5 h → 10 h : 0.8 → 1.0
      return 0.8 + ((s - fiveHours) / (tenHours - fiveHours)) * (1.0 - 0.8);
    } else {
      // 10 h+
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    const armSize = 10;
    final scheme = Theme.of(context).colorScheme;

    return !paintHeatmap
        ? const SizedBox(height: 12, width: 12)
        : Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (date != null) {
                  final durationText = DateTimeFormatter.formatDurationSeconds(
                    seconds,
                  );
                  showInfoSnackBar(
                    context,
                    iconPath: SvgPaths.square,
                    iconColor: seconds > 30 * 60
                        ? Theme.of(context).colorScheme.primaryContainer
                              .withValues(alpha: getOpacity(seconds))
                        : Theme.of(context).colorScheme.surface,
                    message:
                        '$durationText on ${DateTimeFormatter.weekdayName(date!)}, ${DateTimeFormatter.readableDate(date!)}',
                  );
                }
              },
              borderRadius: .circular(2),
              child: Ink(
                padding: const .all(1),
                child: Stack(
                  children: [
                    Ink(
                      width: armSize.toDouble(),
                      height: armSize.toDouble(),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: .circular(2),
                      ),
                    ),
                    Ink(
                      width: armSize.toDouble(),
                      height: armSize.toDouble(),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer.withValues(
                          alpha: getOpacity(seconds),
                        ),
                        borderRadius: .circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
