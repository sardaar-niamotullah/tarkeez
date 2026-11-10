import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';
import 'package:tarkeez/features/sessions/presentation/widgets/session_info_tile.dart';

class SessionsSection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final isInitialLoading =
            state is SessionInitial ||
            (state is SessionLoading && state.isInitialLoad);
        final sessions = switch (state) {
          SessionLoaded(:final sessions) => sessions,
          SessionLoading(:final sessions) => sessions,
          SessionFailure(:final sessions) => sessions,
          SessionInitial() => const [],
        };
        return SliverMainAxisGroup(
          slivers: [
            if (isInitialLoading)
              SliverToBoxAdapter(
                child: LinearProgressIndicator(
                  minHeight: 3,
                  borderRadius: ContainerDesignUtils.allRadius,
                  backgroundColor: scheme.surface,
                ),
              ),
            if (sessions.isNotEmpty)
              SliverList.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: .symmetric(
                      horizontal: context.lg ? 0 : ContainerDesignUtils.padding,
                    ),
                    child: SessionInfoTile(
                      session: sessions[index],
                      backgroundColor: index.isEven
                          ? scheme.surface
                          : scheme.onSurface,
                    ),
                  );
                },
              ),
            if (sessions.isEmpty &&
                !isInitialLoading &&
                state is! SessionFailure)
              SliverToBoxAdapter(
                child: Padding(
                  padding: .only(
                    top: 184,
                    left: context.lg ? 0 : ContainerDesignUtils.padding,
                    right: context.lg ? 0 : ContainerDesignUtils.padding,
                  ),
                  child: Text(
                    'No sessions to show for this period',
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
                  padding: .only(
                    top: 128,
                    left: context.lg ? 0 : ContainerDesignUtils.padding,
                    right: context.lg ? 0 : ContainerDesignUtils.padding,
                  ),
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

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        );
      },
    );
  }
}
