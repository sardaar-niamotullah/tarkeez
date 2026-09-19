import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationTab { home, reports, projects, profile }

class NavigationCubit extends Cubit<NavigationTab> {
  NavigationCubit() : super(NavigationTab.home);

  void navigateTo(NavigationTab tab) => emit(tab);

  int get currentIndex => NavigationTab.values.indexOf(state);
}
