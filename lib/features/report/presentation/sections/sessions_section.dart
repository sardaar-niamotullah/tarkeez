import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/img_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/section_image_lock_overlay.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/session_info_tile.dart';

class SessionsSection extends StatelessWidget {
  final bool isLocked;
  const SessionsSection({super.key, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
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
            if (isLocked)
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
            if (!isLocked)
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
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        );
      },
    );
  }
}
