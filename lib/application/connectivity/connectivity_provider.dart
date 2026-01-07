import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  // ✅ 1. IMMEDIATELY emit current connectivity state
  final initialResult = await connectivity.checkConnectivity();
  yield initialResult != ConnectivityResult.none;

  // ✅ 2. Then listen for future changes
  await for (final result in connectivity.onConnectivityChanged) {
    yield result != ConnectivityResult.none;
  }
});
