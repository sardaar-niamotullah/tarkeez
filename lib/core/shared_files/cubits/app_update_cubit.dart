import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tarkeez/core/services/sync_service.dart';
import 'package:tarkeez/core/sync/sync_remote_source.dart';
import 'package:tarkeez/core/sync/sync_status.dart';

/// The state is the store link while an update is available, otherwise null.
/// Checked after every successful sync run.
class AppUpdateCubit extends Cubit<String?> {
  new(this._remote, SyncService syncService) : super(null) {
    _sub = syncService.statuses.listen((status) {
      if (status.phase == SyncPhase.succeeded) unawaited(_check());
    });
  }

  final SyncRemoteSource _remote;
  late final StreamSubscription<SyncStatus> _sub;

  Future<void> _check() async {
    try {
      final platform = kIsWeb
          ? 'web'
          : defaultTargetPlatform.name.toLowerCase();
      final row = await _remote.fetchAppVersion(platform);

      final installed = int.tryParse(
        (await PackageInfo.fromPlatform()).buildNumber,
      );
      if (installed == null) return;

      final hasUpdate =
          (row['update_notification_enabled'] as bool) &&
          installed < (row['latest_build'] as int);

      if (!isClosed) emit(hasUpdate ? row['store_url'] as String : null);
    } catch (_) {
      // Offline or a bad row: keep the current state. The next sync tries again.
    }
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}