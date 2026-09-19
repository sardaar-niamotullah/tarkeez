import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/buttons/custom_dropdown_button.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/features/report/presentation/sections/report_bar_chart.dart';
import 'package:tarkeez/features/report/presentation/sections/report_line_chart.dart';

class TimelineSection extends StatefulWidget {
  const new({super.key});

  @override
  State<TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<TimelineSection> {
  String _selectedChartType = 'Bar chart';
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: .only(
            top: ContainerDesignUtils.quarterPadding,
            bottom: ContainerDesignUtils.quarterPadding,
            left: ContainerDesignUtils.halfPadding,
            right: ContainerDesignUtils.padding,
          ),
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              CustomDropdownButton<String>(
                items: const ['Bar chart', 'Line chart'],
                buttonWidth: 130,
                buttonColor: scheme.surface,
                initialValue: _selectedChartType,
                labelBuilder: (value) => value,
                onChanged: (value) {
                  setState(() => _selectedChartType = value);
                },
              ),
              DurationTextUtils(
                durationInSeconds: 12345,
                fontSizePrimary: 18,
                fontSizeSeconday: 14,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _selectedChartType == 'Bar chart'
            ? const ReportBarChart()
            : const ReportLineChart(),
      ],
    );
  }
}
