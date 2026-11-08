import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:tarkeez/core/shared_files/cubits/navigation_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/session_timer_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/user_preferences_cubit.dart';
import 'package:tarkeez/core/sync/bloc/sync_bloc.dart';
import 'package:tarkeez/features/auth/bloc/auth_bloc.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/project_rollups/bloc/project_rollup_bloc.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';

class AppProviders extends StatelessWidget {
  const new({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => getIt<UserPreferencesCubit>()),
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<SyncBloc>()),
        BlocProvider(create: (_) => getIt<ProjectBloc>()),
        BlocProvider(create: (_) => getIt<SessionBloc>()),
        BlocProvider(create: (_) => getIt<DailyRollupBloc>()),
        BlocProvider(create: (_) => getIt<ProjectRollupBloc>()),
        BlocProvider(
          create: (_) =>
              SessionTimerCubit(getIt<SessionBloc>(), getIt<SoundService>()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          // A session was saved, failed to save, or deleted: re-read the stats.
          BlocListener<SessionBloc, SessionState>(
            listenWhen: (_, current) =>
                current is SessionFailure ||
                (current is SessionLoaded &&
                    (current.isEntered || current.isDeleted)),
            listener: (context, state) {
              final daily = context.read<DailyRollupBloc>();
              final projects = context.read<ProjectRollupBloc>();
              if (state is SessionLoaded && state.isDeleted) {
                // Another session may be running: reload only.
                daily.add(DailyRollupSynced());
                projects.add(ProjectRollupSynced());
              } else {
                // Entered, or failed to enter: the running part is now in
                // SQLite, so swap the live part for the saved rows.
                daily.add(DailyRollupLiveStopped());
                projects.add(ProjectRollupLiveStopped());
              }
            },
          ),
          // Running session -> live stats. Stopping is handled by the
          // listener above, once the session is saved.
          BlocListener<SessionTimerCubit, SessionTimerState>(
            listenWhen: (_, current) => current.isRunning,
            listener: (context, timer) {
              final startedAt = timer.startedAt!;
              context.read<DailyRollupBloc>().add(
                DailyRollupLiveTicked(startedAt),
              );
              context.read<ProjectRollupBloc>().add(
                ProjectRollupLiveTicked(startedAt, timer.project?.id),
              );
            },
          ),
        ],
        child: child,
      ),
    );
  }
}
