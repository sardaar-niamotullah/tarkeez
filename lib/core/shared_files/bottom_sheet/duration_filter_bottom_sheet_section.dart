import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/filter_duration_selector_button.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';

class DurationFilterBottomSheetSection extends StatelessWidget {
  const DurationFilterBottomSheetSection({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final PeriodRange selected;
  final ValueChanged<PeriodRange> onSelected;

  @override
  Widget build(BuildContext context) {
    const options = PeriodRange.values;
    final rowCount = (options.length / 2).ceil();

    return ListView.builder(
      padding: .zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rowCount,
      itemBuilder: (context, rowIndex) {
        final leftIndex = rowIndex; // first column: 0..rowCount-1
        final rightIndex = rowIndex + rowCount; // second column: rowCount..end
        final hasRight = rightIndex < options.length;

        return Padding(
          padding: .only(bottom: rowIndex == rowCount - 1 ? 0 : 8),
          child: Row(
            children: [
              Expanded(child: _buildButton(options[leftIndex])),
              const SizedBox(width: 8),
              if (hasRight)
                Expanded(child: _buildButton(options[rightIndex]))
              else
                const Spacer(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(PeriodRange option) {
    return FilterDurationSelectorButton(
      title: option.label,
      isSelected: option == selected,
      isLocked: option.isLocked,
      onTap: () => onSelected(option),
    );
  }
}
