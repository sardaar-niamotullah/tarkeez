import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/shared_files/cubits/report_period_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/session_period_cubit.dart';
import 'package:tarkeez/core/sync/bloc/sync_bloc.dart';
import 'package:tarkeez/features/auth/bloc/auth_bloc.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/project_rollups/bloc/project_rollup_bloc.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/navigation_cubit.dart';

class AppProviders extends StatelessWidget {
  const new({super.key, required this.child, required this.initialTheme});

  final Widget child;
  final ThemeState initialTheme;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(initialState: initialTheme)),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => ReportPeriodCubit()),
        BlocProvider(create: (_) => SessionPeriodCubit()),
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<SyncBloc>()),
        BlocProvider(create: (_) => getIt<ProjectBloc>()),
        BlocProvider(create: (_) => getIt<SessionBloc>()),
        BlocProvider(create: (_) => getIt<DailyRollupBloc>()),
        BlocProvider(create: (_) => getIt<ProjectRollupBloc>()),
      ],
      child: BlocListener<SessionBloc, SessionState>(
        listenWhen: (_, current) =>
            current is SessionLoaded &&
            (current.isEntered || current.isDeleted),
        listener: (context, _) {
          context.read<DailyRollupBloc>().add(DailyRollupSynced());
          context.read<ProjectRollupBloc>().add(ProjectRollupSynced());
        },
        child: child,
      ),
    );
  }
}
