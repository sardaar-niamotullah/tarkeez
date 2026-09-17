import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/filter_duration_selector_button.dart';

enum DurationFilterOption {
  today('Today'),
  lastMonth('Last month', isLocked: true),
  yesterday('Yesterday'),
  thisYear('This year', isLocked: true),
  last3Days('Last 3 days'),
  lastYear('Last year', isLocked: true),
  last5Days('Last 5 days'),
  this7Days('Last 7 days', isLocked: true),
  thisWeek('This week'),
  last30Days('Last 30 days', isLocked: true),
  lastWeek('Last week'),
  last12Months('Last 12 months', isLocked: true),
  thisMonth('This month'),
  allTime('All time', isLocked: true);

  const DurationFilterOption(this.title, {this.isLocked = false});
  final String title;
  final bool isLocked;
}

class DurationFilterBottomSheetSection extends StatefulWidget {
  const DurationFilterBottomSheetSection({super.key});

  @override
  State<DurationFilterBottomSheetSection> createState() =>
      _DurationFilterBottomSheetSectionState();
}

class _DurationFilterBottomSheetSectionState
    extends State<DurationFilterBottomSheetSection> {
  DurationFilterOption _selected = DurationFilterOption.last3Days;

  @override
  Widget build(BuildContext context) {
    const options = DurationFilterOption.values;
    final rowCount = (options.length / 2).ceil();

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rowCount,
      itemBuilder: (context, rowIndex) {
        final firstIndex = rowIndex * 2;
        final secondIndex = firstIndex + 1;
        final hasSecond = secondIndex < options.length;

        return Padding(
          padding: EdgeInsets.only(bottom: rowIndex == rowCount - 1 ? 0 : 8),
          child: Row(
            children: [
              Expanded(child: _buildButton(options[firstIndex])),
              if (hasSecond) ...[
                const SizedBox(width: 8),
                Expanded(child: _buildButton(options[secondIndex])),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(DurationFilterOption option) {
    return FilterDurationSelectorButton(
      title: option.title,
      isSelected: option == _selected,
      isLocked: option.isLocked,
      onTap: () => setState(() => _selected = option),
    );
  }
}
