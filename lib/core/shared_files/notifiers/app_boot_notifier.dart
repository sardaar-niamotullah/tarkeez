import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/core/di/dependency_injection.dart';
import 'package:tarkeez/core/utils/connectivity_utils.dart';
import 'package:tarkeez/features/profile/bloc/profile_bloc.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/bloc/project_color_bloc.dart';

enum AppBootState { initializing, noInternet, unauthenticated, authenticated }

class AppBootNotifier extends ChangeNotifier {
  final SupabaseClient _supabase;

  StreamSubscription<AuthState>? _authSub;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  AppBootState _state = AppBootState.initializing;
  AppBootState get state => _state;

  bool _hasBootstrapped = false;
  bool _isResolving = false;

  AppBootNotifier(this._supabase) {
    _init();
  }

  Future<void> _init() async {
    await _resolveBootState();
    _hasBootstrapped = true;

    _authSub = _supabase.auth.onAuthStateChange.listen((_) async {
      await _resolveBootState();
    });

    _connectivitySub = Connectivity().onConnectivityChanged.listen((
      results,
    ) async {
      final hasInterface = results.any((r) => r != ConnectivityResult.none);

      if (!hasInterface) {
        // No network interface at all — show immediately, no HTTP check needed
        ConnectivityUtils.showNoInternetSnackbar();
        return;
      }

      // Has interface — do the real HTTP check
      final connected = await ConnectivityUtils.hasInternet();

      if (connected) {
        ConnectivityUtils.hideNoInternetSnackbar();
        // Only retry boot if we were stuck in noInternet during startup
        if (_state == AppBootState.noInternet) await _resolveBootState();
      } else {
        ConnectivityUtils.showNoInternetSnackbar();
      }
    });
  }

  Future<void> _resolveBootState() async {
    if (_isResolving) return;
    _isResolving = true;

    try {
      if (!_hasBootstrapped) _setState(AppBootState.initializing);

      // ── connectivity gate ────────────────────────────────────────────────
      final connected = await ConnectivityUtils.hasInternet();
      if (!connected) {
        _setState(AppBootState.noInternet);
        return;
      }
      // ────────────────────────────────────────────────────────────────────

      final session = _supabase.auth.currentSession;
      if (session == null) {
        getIt<ProfileBloc>().add(ProfileReset());
        _setState(AppBootState.unauthenticated);
        return;
      }

      await Future.wait([
        _preloadProfile(),
        _preloadProjectColors(),
        _preloadProjects(),
      ]);
      _setState(AppBootState.authenticated);
    } finally {
      _isResolving = false;
    }
  }

  Future<void> _preloadProfile() async {
    final profileBloc = getIt<ProfileBloc>();
    if (profileBloc.state is ProfileLoaded) return;
    profileBloc.add(FetchProfileRequested());
    await profileBloc.stream.firstWhere((s) => s is! ProfileLoading);
  }

  Future<void> _preloadProjectColors() async {
    final projectColorBloc = getIt<ProjectColorBloc>();
    if (projectColorBloc.state is ProjectColorLoaded) return;
    projectColorBloc.add(FetchProjectColorsEvent());
    await projectColorBloc.stream.firstWhere((s) => s is! ProjectColorLoading);
  }

  Future<void> _preloadProjects() async {
    final projectBloc = getIt<ProjectBloc>();
    if (projectBloc.state is ProjectLoaded) return;
    projectBloc.add(FetchProjectsRequested());
    await projectBloc.stream.firstWhere((s) => s is! ProjectLoading);
  }

  void onboardingCompleted() => _setState(AppBootState.authenticated);

  void _setState(AppBootState newState) {
    if (_state == newState) return;
    _state = newState;

    if (_state == AppBootState.noInternet) {
      ConnectivityUtils.showNoInternetSnackbar();
    } else {
      ConnectivityUtils.hideNoInternetSnackbar();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _connectivitySub?.cancel();
    super.dispose();
  }
}
