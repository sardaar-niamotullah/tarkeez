import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_title_tile.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/duration_filter_bottom_sheet_section.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/utils/date_formatter.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/leaderboard/presentation/sections/widgets/rank_area_selection_segmented_picker.dart';

class LeaderboardFilterBottomSheet extends StatefulWidget {
  const LeaderboardFilterBottomSheet({super.key});

  @override
  State<LeaderboardFilterBottomSheet> createState() =>
      _LeaderboardFilterBottomSheetState();
}

class _LeaderboardFilterBottomSheetState
    extends State<LeaderboardFilterBottomSheet> {
  RankAreaType _selectedArea = RankAreaType.global;
  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final scheme = Theme.of(context).colorScheme;
    return BottomSheetWrapper(
      contents: [
        BottomSheetTitleTile(
          title: texts.leaderboardFilter,
          iconPath: SvgPaths.filter,
        ),
        Align(
          alignment: .centerLeft,
          child: Text.rich(
            TextSpan(
              style: TextUtils.paragraphXs(
                context,
                color: scheme.onTertiary.withValues(alpha: .7),
              ),
              children: [
                const TextSpan(
                  text: 'Leaderboard uses UTC time, Current UTC: ',
                ),
                TextSpan(
                  text: DateFormatter.readableDateTime(DateTime.now().toUtc()),
                  style: TextStyle(fontWeight: .bold, color: scheme.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
        // Duration seletion option
        //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
        Align(
          alignment: .centerLeft,
          child: Text('Duration', style: TextUtils.title3(context)),
        ),
        const SizedBox(height: 8),
        const DurationFilterBottomSheetSection(),
        const SizedBox(height: 8),

        //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
        // Scope seletion option
        //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
        Align(
          alignment: .centerLeft,
          child: Text('Scope', style: TextUtils.title3(context)),
        ),
        const SizedBox(height: 8),
        RankAreaSelectionSegmentedPicker(
          value: _selectedArea,
          onChanged: (newValue) {
            setState(() {
              _selectedArea = newValue;
            });
          },
        ),
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
