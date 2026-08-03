import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'offline_sync_manager.dart';

/// রিয়েল-টাইম নেটওয়ার্ক কানেক্টিভিটি পর্যবেক্ষণ এবং অটো-সিঙ্ক সার্ভিস
class NetworkConnectivityService {
  static final NetworkConnectivityService _instance = NetworkConnectivityService._internal();
  factory NetworkConnectivityService() => _instance;
  NetworkConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final ValueNotifier<bool> isOnlineNotifier = ValueNotifier<bool>(true);
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _wasOffline = false;

  void initialize() {
    _checkInitialStatus();
    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
    OfflineSyncManager.getPendingTaskCount();
  }

  Future<void> _checkInitialStatus() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateStatus(results);
    } catch (_) {}
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final isOnline = results.any((r) => r != ConnectivityResult.none);
    isOnlineNotifier.value = isOnline;

    if (isOnline) {
      if (_wasOffline) {
        OfflineSyncManager.syncPendingQueue();
      } else {
        OfflineSyncManager.syncPendingQueue();
      }
    }
    _wasOffline = !isOnline;
  }

  Future<bool> get isOnline async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      return true;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
