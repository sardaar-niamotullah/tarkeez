import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/color_from_hex_code.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/project_info_tile.dart';

class ProjectsPieChartSection extends StatefulWidget {
  const ProjectsPieChartSection({super.key});

  @override
  State<ProjectsPieChartSection> createState() => PieChart2State();
}

class PieChart2State extends State<ProjectsPieChartSection> {
  int touchedIndex = -1;

  // Each entry: [name, code, durationInMinutes]
  final List<List<dynamic>> data = [
    ['Name', '#921334', 124],
    ['Name2', '#721612', 224],
    ['Name3', '#897652', 324],
    ['Name4', '#876128', 424],
    ['Name5', '#562781', 524],
    ['Name6', '#522721', 100],
  ];

  List<List<dynamic>> get sortedData =>
      List<List<dynamic>>.from(data)
        ..sort((a, b) => (b[2] as int).compareTo(a[2] as int));
  int get totalMinutes =>
      data.fold<int>(0, (sum, item) => sum + (item[2] as int));
  int get totalHours => totalMinutes ~/ 60;
  int get remainderMinutes => totalMinutes % 60;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Projects', style: TextUtils.title2(context)),
        const SizedBox(height: 8),
        Container(
          padding: const .only(top: 36, left: 16, right: 16),
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                  // Total duration
                  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                  Expanded(
                    child: DurationTextUtils(
                      durationInSeconds: 12345,
                      fontSizePrimary: 24,
                      fontSizeSeconday: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                  // Pie chart
                  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 48,
                          borderData: FlBorderData(show: true),
                          sections: showingSections(),
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (
                                  FlTouchEvent event,
                                  PieTouchResponse? pieTouchResponse,
                                ) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!
                                        .touchedSectionIndex;
                                  });
                                },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 36),

              //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
              // Project details
              //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
              Container(
                padding: const .symmetric(
                  horizontal: ContainerDesignUtils.padding,
                ),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: ContainerDesignUtils.allRadius,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sortedData.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    final project = sortedData[i];
                    final tileColor = i.isEven
                        ? scheme.surface
                        : scheme.onSurface;
                    return ProjectInfoTile(
                      project: ProjectModel(
                        userId: '1',
                        name: project[0] as String,
                        colorId: 1,
                        createdAt: DateTime(2026)
                      ),
                      tileColor: tileColor,
                      durationInSeconds: project[2] as int,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(sortedData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 12 : 10;
      final radius = isTouched ? 60.0 : 50.0;

      final int duration = sortedData[i][2] as int;

      final double percentage =
          ((duration / totalMinutes) * 100 * 10).ceil() / 10;

      return PieChartSectionData(
        color: colorFromHexCode(sortedData[i][1] as String),
        value: duration.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        cornerRadius: 12,
        titleStyle: TextUtils.paragraphBold(
          context,
          color: AppTheme.white,
        ).copyWith(fontSize: fontSize.toDouble()),
      );
    });
  }
}
