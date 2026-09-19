import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/shared_files/cubits/navigation_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';

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
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => getIt<ProjectBloc>()),
      ],
      child: child 
    );
  }
}
