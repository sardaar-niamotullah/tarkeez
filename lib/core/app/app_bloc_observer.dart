import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('🟢 CREATED => ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('📨 EVENT => ${bloc.runtimeType}, $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('🚀 🚀 🚀 🚀 TRANSITION => ${bloc.runtimeType}');
    debugPrint('🚀 🚀 🚀 Event: ${transition.event}');
    debugPrint('🚀 🚀 Current: ${transition.currentState}');
    debugPrint('🚀 Next: ${transition.nextState}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('🔄 🔄 🔄 CHANGE => ${bloc.runtimeType}');
    debugPrint('🔄 🔄 Current: ${change.currentState}');
    debugPrint('🔄 Next: ${change.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('🔴 🔴 ERROR => ${bloc.runtimeType}');
    debugPrint('🔴 Error: $error');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint('🚪 CLOSED => ${bloc.runtimeType}');
  }
}
