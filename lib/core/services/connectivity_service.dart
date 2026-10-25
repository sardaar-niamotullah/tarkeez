import 'package:connectivity_plus/connectivity_plus.dart';

/// Tells whether the device has a network connection.
/// It only means a network is up. A request can still fail, and sync handles
/// that by leaving the rows in `pending_changes`.
class ConnectivityService {
  final _connectivity = Connectivity();

  Future<bool> get isOnline async =>
      _hasNetwork(await _connectivity.checkConnectivity());

  Stream<bool> get onlineChanges =>
      _connectivity.onConnectivityChanged.map(_hasNetwork).distinct();

  static bool _hasNetwork(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
