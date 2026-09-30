import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/img_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/section_image_lock_overlay.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/daily_rollups/data/models/heatmap_day.dart';
import 'package:tarkeez/features/daily_rollups/stats/heatmap_stats.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/heatmap_point.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/heatmap_title_and_guide_tile.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/heatmap_weekdays_name.dart';

class Heatmap extends StatelessWidget {
  const new({super.key, required this.isLocked});

  final bool isLocked;

  List<HeatmapDay> _resolveGrid(DailyRollupState state) {
    if (state is DailyRollupLoaded) return state.heatmapGrid;
    if (state is DailyRollupLoading && state.rollupsByDate != null) {
      return HeatmapStats.buildGrid(state.rollupsByDate!);
    }
    return HeatmapStats.buildGrid(const {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 680,
      child: Column(
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
            BlocBuilder<DailyRollupBloc, DailyRollupState>(
              builder: (context, state) {
                final grid = _resolveGrid(state);
                return Container(
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
                                  HeatmapStats.daysPerWeek,
                                  (rowIndex) => SizedBox(
                                    height: 12,
                                    child: Row(
                                      children: List.generate(
                                        HeatmapStats.weeksToShow,
                                        (columnIndex) {
                                          final day =
                                              grid[columnIndex *
                                                      HeatmapStats.daysPerWeek +
                                                  rowIndex];
                                          return HeatmapPoint(
                                            seconds: day.durationSeconds,
                                            date: day.isFuture
                                                ? null
                                                : day.date,
                                            paintHeatmap: !day.isFuture,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: List.generate(
                                  HeatmapStats.weeksToShow,
                                  (columnIndex) {
                                    final columnStart =
                                        grid[columnIndex *
                                                HeatmapStats.daysPerWeek]
                                            .date;
                                    final label =
                                        HeatmapStats.monthLabelForColumn(
                                          columnStart,
                                        );
                                    return SizedBox(
                                      width: 12,
                                      child: Center(
                                        child: Text(
                                          label ?? '',
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.visible,
                                          style: TextUtils.paragraphSmall(
                                            context,
                                          ).copyWith(fontSize: 10),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
