import 'package:tarkeez/core/shared_files/cubits/language_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/navigation_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      ],
      child: child 
    );
  }
}
