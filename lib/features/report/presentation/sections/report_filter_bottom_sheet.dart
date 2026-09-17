import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_title_tile.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/duration_filter_bottom_sheet_section.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';

class ReportFilterBottomSheet extends StatelessWidget {
  const ReportFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      contents: [
        BottomSheetTitleTile(
          title: 'Report filter',
          iconPath: SvgPaths.filter,
        ),
        const SizedBox(height: 16),
        const DurationFilterBottomSheetSection(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: CancelButton(onPressed: () => context.pop())),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(title: 'Apply', onPressed: () {}),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
