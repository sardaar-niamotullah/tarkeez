import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/utils/date_time_formatter.dart';

class HeatmapPoint extends StatelessWidget {
  final int minute;
  final DateTime? date;
  final bool paintHeatmap;
  const HeatmapPoint({
    super.key,
    required this.minute,
    this.date,
    this.paintHeatmap = true,
  });

  double getOpacity(num minutes) {
    final m = minutes.toDouble();

    const fiveHours = 5 * 60; // 300
    const tenHours = 10 * 60; // 600

    if (m < 15) {
      // 0 - 14 min
      return 0.0;
    } else if (m <= fiveHours) {
      // 15 min -> 5 hr : 0.2 -> 0.8
      return 0.2 + ((m - 15) / (fiveHours - 15)) * (0.8 - 0.2);
    } else if (m <= tenHours) {
      // 5 hr -> 10 hr : 0.8 -> 1.0
      return 0.8 + ((m - fiveHours) / (tenHours - fiveHours)) * (1.0 - 0.8);
    } else {
      // 10 hr+
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    int armSize = 10;
    return !paintHeatmap
        ? SizedBox(height: 12, width: 12)
        : Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (date != null) {
                  final durationText = DateTimeFormatter.formatDurationMinutes(
                    minute,
                  );
                  showInfoSnackBar(
                    context,
                    iconPath: SvgPaths.square,
                    iconColor: minute > 15
                        ? Theme.of(context).colorScheme.primaryContainer
                              .withValues(alpha: getOpacity(minute))
                        : Theme.of(context).colorScheme.surface,
                    message:
                        '$durationText on ${DateTimeFormatter.weekdayName(date!)}, ${DateTimeFormatter.readableDate(date!)}',
                  );
                }
              },
              borderRadius: BorderRadius.circular(2),
              child: Ink(
                padding: .all(1),
                child: Stack(
                  children: [
                    Ink(
                      width: armSize.toDouble(),
                      height: armSize.toDouble(),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Ink(
                      width: armSize.toDouble(),
                      height: armSize.toDouble(),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer
                            .withValues(alpha: getOpacity(minute)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
