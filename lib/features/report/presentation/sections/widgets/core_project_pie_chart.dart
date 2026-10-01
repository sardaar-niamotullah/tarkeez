import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/project_colors.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_duration_model.dart';

class CoreProjectPieChart extends StatefulWidget {
  const new({super.key, required this.projectDurations});

  final List<ProjectDurationModel> projectDurations;

  @override
  State<CoreProjectPieChart> createState() => _CoreProjectPieChartState();
}

class _CoreProjectPieChartState extends State<CoreProjectPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final projectColors = ProjectColors.colors;
    final scheme = Theme.of(context).colorScheme;
    final totalSeconds = widget.projectDurations.fold<int>(
      0,
      (sum, entry) => sum + entry.durationInSeconds,
    );
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 48,
        borderData: FlBorderData(show: true),
        sections: _showingSections(
          widget.projectDurations,
          totalSeconds,
          projectColors,
          scheme,
          context,
        ),
        pieTouchData: PieTouchData(
          touchCallback:
              (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections(
    List<ProjectDurationModel> projectDurations,
    int totalSeconds,
    List<Color> projectColors,
    ColorScheme scheme,
    BuildContext context,
  ) {
    return List.generate(projectDurations.length, (i) {
      final entry = projectDurations[i];
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 12 : 10;
      final radius = isTouched ? 60.0 : 50.0;

      final resolvedColor = entry.project != null
          ? projectColors[entry.project!.colorId]
          : scheme.onTertiary;

      final percentage = totalSeconds == 0
          ? 100.0
          : ((entry.durationInSeconds / totalSeconds) * 100 * 10).ceil() / 10;

      return PieChartSectionData(
        color: resolvedColor,
        value: totalSeconds == 0 ? 1 : entry.durationInSeconds.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        cornerRadius: 12,
        titleStyle: TextUtils.paragraphBold(
          context,
          color: scheme.tertiary,
        ).copyWith(fontSize: fontSize.toDouble()),
      );
    });
  }
}
