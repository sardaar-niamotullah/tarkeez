import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_title_tile.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/duration_filter_bottom_sheet_section.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/cubits/user_preferences_cubit.dart';
import 'package:tarkeez/core/shared_files/enums/user_preference_enums.dart';

class ReportFilterBottomSheet extends StatefulWidget {
  const new({super.key});

  @override
  State<ReportFilterBottomSheet> createState() =>
      _ReportFilterBottomSheetState();
}

class _ReportFilterBottomSheetState extends State<ReportFilterBottomSheet> {
  late PeriodRange _pending;

  @override
  void initState() {
    super.initState();
    _pending = context.read<UserPreferencesCubit>().state.reportPeriod;
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      contents: [
        BottomSheetTitleTile(title: 'Report filter', iconPath: SvgPaths.filter),
        const SizedBox(height: 16),
        DurationFilterBottomSheetSection(
          selected: _pending,
          onSelected: (period) {
            // Locked options already trigger GoPremiumDialog inside
            // FilterDurationSelectorButton and never reach here selectable.
            if (period.isPremium) return;
            setState(() => _pending = period);
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: CancelButton(onPressed: () => context.pop())),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                title: 'Apply',
                onPressed: () {
                  context.read<UserPreferencesCubit>().setReportPeriod(_pending);
                  context.pop();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
