import 'package:tarkeez/core/app/app_providers.dart';
import 'package:tarkeez/core/routes/app_router.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  final ThemeState initialTheme;

  const App({super.key, required this.initialTheme});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      initialTheme: initialTheme,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Tarkeez',
            routerConfig: router,
            themeMode: themeState.mode,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(themeState.color),
            darkTheme: AppTheme.darkTheme(themeState.color),
          );
        },
      ),
    );
  }
}
