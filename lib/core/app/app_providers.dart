import 'package:tarkeez/core/di/dependency_injection.dart';
import 'package:tarkeez/core/shared_files/cubits/language_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/navigation_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/bloc/project_color_bloc.dart';
import 'package:tarkeez/features/time_logs/bloc/time_log_bloc.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  final ThemeState initialTheme;

  const AppProviders({
    super.key,
    required this.child,
    required this.initialTheme,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(initialState: initialTheme)),
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => getIt<ProfileBloc>()),
        BlocProvider(create: (_) => getIt<ProjectColorBloc>()),
        BlocProvider(create: (_) => getIt<ProjectBloc>()),
        BlocProvider(create: (_) => getIt<TimeLogBloc>()),
      ],
      child: child 
    );
  }
}
