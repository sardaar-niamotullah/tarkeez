import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tarkeez/core/constants/img_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/section_image_lock_overlay.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';
import 'package:tarkeez/features/sessions/data/models/dummy_session.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/session_info_tile.dart';

class SessionsSection extends StatelessWidget {
  final bool isLocked;
  const SessionsSection({super.key, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final isInitialLoading = state is SessionLoading && state.isInitialLoad;
        final sessions = switch (state) {
          SessionLoaded(:final sessions) => sessions,
          SessionLoading(:final sessions) => sessions,
          SessionFailure(:final sessions) => sessions,
          SessionInitial() => const [],
        };
        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Text('Sessions', style: TextUtils.title2(context)),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            if (isLocked) ...[
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return SliverToBoxAdapter(
                    child: SectionImageLockOverlay(
                      imgLocation: state.isDark
                          ? ImgPaths.sessionLockBackdropsDark
                          : ImgPaths.sessionLockBackdropsLight,
                      height: 124,
                      lockedTopicName: 'sessions',
                    ),
                  );
                },
              ),
            ] else ...[
              if (sessions.isNotEmpty)
                SliverList.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    return SessionInfoTile(
                      session: sessions[index],
                      backgroundColor: index.isEven
                          ? scheme.onSurface
                          : scheme.surface,
                    );
                  },
                ),
              if (sessions.isEmpty &&
                  !isInitialLoading &&
                  state is! SessionFailure)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const .only(top: 16),
                    child: Text(
                      'No sessions to show for this date range.',
                      style: TextUtils.paragraph(
                        context,
                        color: scheme.onTertiary.withValues(alpha: .7),
                      ),
                      textAlign: .center,
                    ),
                  ),
                ),
              if (state is SessionFailure)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const .only(top: 128),
                    child: Text(
                      state.errorMessage,
                      style: TextUtils.paragraph(
                        context,
                        color: scheme.onTertiary.withValues(alpha: .7),
                      ),
                      textAlign: .center,
                    ),
                  ),
                ),
              if (isInitialLoading)
                SliverSkeletonizer(
                  enabled: true,
                  child: SliverList.builder(
                    itemCount: 4,
                    itemBuilder: (context, i) => SessionInfoTile(
                      session: DummySession.session,
                      backgroundColor: i.isEven
                          ? scheme.onSurface
                          : scheme.surface,
                    ),
                  ),
                ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        );
      },
    );
  }
}
