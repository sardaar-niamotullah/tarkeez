import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/img_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/section_image_lock_overlay.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/statistics/heatmap/presentation/widgets/heatmap_point.dart';
import 'package:tarkeez/features/statistics/heatmap/presentation/widgets/heatmap_title_and_guide_tile.dart';
import 'package:tarkeez/features/statistics/heatmap/presentation/widgets/heatmap_weekdays_name.dart';

class Heatmap extends StatelessWidget {
  const Heatmap({super.key, required this.isLocked});

  final bool isLocked;

  static const int _weeksToShow = 53;
  static const int _daysPerWeek = 7;

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// Saturday is the first row in the grid.
  DateTime _startOfWeek(DateTime date) {
    final normalized = _dateOnly(date);
    const saturdayIndex = DateTime.saturday;
    final diff =
        (normalized.weekday + _daysPerWeek - saturdayIndex) % _daysPerWeek;
    return normalized.subtract(Duration(days: diff));
  }

  List<DateTime> _buildVisibleDates(DateTime today) {
    final currentWeekStart = _startOfWeek(today);
    final firstVisibleDate = currentWeekStart.subtract(
      const Duration(days: (_weeksToShow - 1) * _daysPerWeek),
    );
    return List.generate(
      _weeksToShow * _daysPerWeek,
      (index) => firstVisibleDate.add(Duration(days: index)),
    );
  }

  int _minuteForDate({
    required DateTime date,
    required DateTime today,
    required List<int> heatMapValues,
  }) {
    if (date.isAfter(today)) {
      return 0;
    }

    final daysAgo = _dateOnly(today).difference(date).inDays;
    if (daysAgo < 0 || daysAgo >= heatMapValues.length) {
      return 0;
    }

    return heatMapValues[daysAgo];
  }

  String? _monthLabelForColumn(
    DateTime columnStart,
    DateTime firstVisibleDate,
  ) {
    final isFirstColumn = columnStart.isAtSameMomentAs(firstVisibleDate);
    final isMonthStartVisible = columnStart.day <= 7;

    if (!isFirstColumn && !isMonthStartVisible) {
      return null;
    }

    const months = <int, String>{
      DateTime.january: 'Jan',
      DateTime.february: 'Feb',
      DateTime.march: 'Mar',
      DateTime.april: 'Apr',
      DateTime.may: 'May',
      DateTime.june: 'Jun',
      DateTime.july: 'Jul',
      DateTime.august: 'Aug',
      DateTime.september: 'Sep',
      DateTime.october: 'Oct',
      DateTime.november: 'Nov',
      DateTime.december: 'Dec',
    };

    return months[columnStart.month];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final today = _dateOnly(DateTime.now());
    final heatMapData =
        "206, 127, 729, 130, 256, 8, 55, 29, 141, 586, 260, 173, 155, 2, 277, 125, 120, 24, 13, 18, 262, 431, 299, 145, 297, 135, 121, 46, 49, 285, 126, 75, 132, 7, 196, 214, 866, 48, 655, 283, 771, 312, 232, 407, 120, 209, 132, 104, 150, 416, 650, 28, 155, 130, 222, 261, 15, 225, 168, 232, 127, 111, 287, 15, 198, 124, 99, 285, 133, 102, 142, 84, 54, 294, 103, 151, 73, 9, 26, 14, 264, 17, 19, 276, 282, 145, 120, 474, 155, 87, 201, 237, 46, 0, 35, 18, 193, 925, 70, 191, 223, 22, 54, 176, 287, 692, 980, 107, 63, 57, 63, 156, 220, 39, 71, 959, 206, 76, 292, 256, 115, 95, 255, 415, 174, 209, 4, 75, 62, 158, 267, 53, 45, 224, 205, 952, 130, 101, 168, 142, 87, 259, 248, 205, 21, 232, 19, 105, 69, 260, 91, 256, 132, 124, 167, 198, 72, 200, 53, 596, 151, 271, 236, 42, 743, 209, 299, 118, 215, 32, 124, 223, 258, 279, 27, 398, 173, 767, 215, 197, 123, 44, 51, 229, 229, 214, 93, 150, 293, 267, 26, 280, 94, 43, 124, 287, 194, 146, 85, 248, 112, 173, 197, 149, 40, 158, 222, 72, 139, 30, 201, 32, 68, 101, 227, 181, 118, 137, 65, 1, 51, 217, 203, 110, 4, 262, 103, 219, 14, 6, 786, 214, 94, 290, 269, 140, 87, 266, 100, 287, 175, 250, 226, 80, 209, 0, 74, 279, 193, 296, 225, 278, 228, 197, 287, 252, 239, 173, 135, 245, 172, 143, 48, 236, 255, 150, 299, 292, 642, 181, 25, 160, 192, 88, 18, 204, 25, 0, 877, 28, 288, 26, 165, 149, 126, 247, 251, 248, 240, 258, 31, 105, 178, 205, 66, 200, 3, 39, 60, 456, 13, 523, 267, 161, 242, 177, 144, 135, 136, 195, 211, 97, 36, 249, 246, 156, 153, 177, 124, 220, 299, 175, 260, 155, 242, 40, 222, 77, 20, 139, 474, 169, 211, 644, 141, 33, 226, 55, 206, 133, 561, 66, 241, 195, 272, 57, 777, 161, 248, 289, 68, 46, 11, 120, 816, 223, 184, 98, 139, 120, 32, 36, 101, 212, 294, 231, 150, 135, 1, 268, 25, 34, 223, 290, 56, 101, 55, 126, 418, 18, 42, 61, 299, 135, 170, 196, 233, 26, 237, 127, 62, 168, 14, 157, 127, 215, 106, 146, 154, 846, 87, 213, 284, 69, 292, 174, 207, 250, 3, 195, 209, 174, 18, 257, 295, 192, 563, 236, 154, 264, 39, 22, 844, 275, 292, 41, 68, 4, 212, 278, 131, 261, 297, 285, 98, 242, 260, 101";
    final List<int> heatMapValues = heatMapData
        .split(',')
        .map((e) => int.parse(e.trim()))
        .toList();
    final visibleDates = _buildVisibleDates(today);

    return Column(
      crossAxisAlignment: .start,
      children: [
        const HeatmapTitleAndGuideTile(),
        const SizedBox(height: 8),

        if (isLocked)
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return SectionImageLockOverlay(
                imgLocation: state.isDark
                    ? ImgPaths.heatmapLockedBackdropsDark
                    : ImgPaths.heatmapLockedBackdropsLight,
                height: 110,
                lockedTopicName: 'heatmap',
              );
            },
          ),
        if (!isLocked)
          Container(
            width: .infinity,
            padding: const .only(top: 8, bottom: 4, left: 8, right: 12),
            decoration: BoxDecoration(
              color: scheme.onSurface,
              borderRadius: ContainerDesignUtils.allRadius,
            ),
            child: Row(
              crossAxisAlignment: .start,
              children: [
                const HeatmapWeekdaysName(),
                Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    scrollDirection: .horizontal,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Column(
                          children: List.generate(
                            _daysPerWeek,
                            (rowIndex) => SizedBox(
                              height: 12,
                              child: Row(
                                children: List.generate(_weeksToShow, (
                                  columnIndex,
                                ) {
                                  final date =
                                      visibleDates[columnIndex * _daysPerWeek +
                                          rowIndex];
                                  final minute = _minuteForDate(
                                    date: date,
                                    today: today,
                                    heatMapValues: heatMapValues,
                                  );
                                  return HeatmapPoint(
                                    minute: minute,
                                    date: date.isAfter(today) ? null : date,
                                    paintHeatmap: !date.isAfter(today),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: List.generate(_weeksToShow, (columnIndex) {
                            final columnStart =
                                visibleDates[columnIndex * _daysPerWeek];
                            final label = _monthLabelForColumn(
                              columnStart,
                              visibleDates.first,
                            );
                            return SizedBox(
                              width: 12,
                              child: Center(
                                child: Text(
                                  label ?? '',
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: .visible,
                                  style: TextUtils.paragraphSmall(context)
                                      .copyWith(fontSize: 10),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
