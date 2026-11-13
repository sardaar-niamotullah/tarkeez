import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/filter_duration_selector_button.dart';
import 'package:tarkeez/core/shared_files/cubits/premium_cubit.dart';
import 'package:tarkeez/core/shared_files/enums/user_preference_enums.dart';

class DurationFilterBottomSheetSection extends StatelessWidget {
  const new({super.key, required this.selected, required this.onSelected});

  final PeriodRange selected;
  final ValueChanged<PeriodRange> onSelected;

  @override
  Widget build(BuildContext context) {
    const options = PeriodRange.values;
    final rowCount = (options.length / 2).ceil();
    final isPremiumUser = context.select((PremiumCubit c) => c.isPremium);

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
              Expanded(
                child: _buildButton(
                  option: options[leftIndex],
                  isPremiumUser: isPremiumUser,
                ),
              ),
              const SizedBox(width: 8),
              if (hasRight)
                Expanded(
                  child: _buildButton(
                    option: options[rightIndex],
                    isPremiumUser: isPremiumUser,
                  ),
                )
              else
                const Spacer(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required PeriodRange option,
    required bool isPremiumUser,
  }) {
    return FilterDurationSelectorButton(
      title: option.label,
      isSelected: option == selected,
      isLocked: option.isPremium && !isPremiumUser,
      onTap: () => onSelected(option),
    );
  }
}
