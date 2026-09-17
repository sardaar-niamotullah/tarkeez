import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/img_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/section_image_lock_overlay.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/time_log_session_info_tile.dart';
import 'package:tarkeez/features/sessions/data/models/time_log_model.dart';

class TimeLogSessionsSection extends StatelessWidget {
  final bool isLocked;
  const TimeLogSessionsSection({super.key, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Text('Sessions', style: TextUtils.title2(context)),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        if (isLocked)
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return SliverToBoxAdapter(
                child: SectionImageLockOverlay(
                  imgLocation: state.isDark
                      ? ImgPaths.timeLogsLockBackdropsDark
                      : ImgPaths.timeLogsLockBrackdropsLight,
                  height: 124,
                  lockedTopicName: 'sessions',
                ),
              );
            },
          ),
        if (!isLocked)
          SliverList.builder(
            itemCount: 12,
            itemBuilder: (context, index) {
              return TimeLogSessionInfoTile(
                timeLog: SessionModel(startedAt: DateTime(2025), endedAt: DateTime.now(), userId: '1'),
                backgroundColor: index.isEven
                    ? scheme.onSurface
                    : scheme.surface,
              );
            },
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
