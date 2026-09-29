import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/filter_duration_selector_button.dart';
import 'package:tarkeez/core/shared_files/enums/report_period.dart';

class DurationFilterBottomSheetSection extends StatelessWidget {
  const DurationFilterBottomSheetSection({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final ReportPeriod selected;
  final ValueChanged<ReportPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    const options = ReportPeriod.values;
    final rowCount = (options.length / 2).ceil();

    return ListView.builder(
      padding: .zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rowCount,
      itemBuilder: (context, rowIndex) {
        final firstIndex = rowIndex * 2;
        final secondIndex = firstIndex + 1;
        final hasSecond = secondIndex < options.length;

        return Padding(
          padding: .only(bottom: rowIndex == rowCount - 1 ? 0 : 8),
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

  Widget _buildButton(ReportPeriod option) {
    return FilterDurationSelectorButton(
      title: option.label,
      isSelected: option == selected,
      isLocked: option.isLocked,
      onTap: () => onSelected(option),
    );
  }
}
