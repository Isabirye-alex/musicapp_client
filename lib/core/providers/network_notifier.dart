import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_notifier.g.dart';

@Riverpod(keepAlive: true)
class NetworkNotifier extends _$NetworkNotifier {
  StreamSubscription? _subscription;
  Timer? _timer;

  @override
  bool build() {
    _checkInternet(); // check immediately on start

    // Listen for connectivity changes, then verify actual internet
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasNetwork = results.any((r) => r != ConnectivityResult.none);
      if (hasNetwork) {
        _checkInternet(); // only ping if network is available
      } else {
        state = false; // no network at all, no need to ping
      }
    });

    //poll every 5 seconds to catch silent drops
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkInternet();
    });

    ref.onDispose(() {
      _subscription?.cancel();
      _timer?.cancel();
    });

    return true;
  }

  Future<void> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      state = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      state = false;
    } on TimeoutException {
      state = false;
    }
  }
}