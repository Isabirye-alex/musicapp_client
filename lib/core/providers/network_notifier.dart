import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_notifier.g.dart';

@Riverpod(keepAlive: true)
class NetworkNotifier extends _$NetworkNotifier {
  StreamSubscription? _subscription;

  @override
  bool build() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      state = results.any((r) => r != ConnectivityResult.none);
    });

    // Cancel subscription when provider is disposed
    ref.onDispose(() => _subscription?.cancel());

    return true; 
  }
}