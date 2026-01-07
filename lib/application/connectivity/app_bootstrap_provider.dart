import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopx/application/auth/auth_notifier.dart';
import 'package:shopx/application/connectivity/connectivity_provider.dart';

enum AppBootstrapState {
  loading,
  offline,
  ready,
}

final appBootstrapProvider = Provider<AppBootstrapState>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  final auth = ref.watch(authNotifierProvider);

  return connectivity.when(
    loading: () => AppBootstrapState.loading,
    error: (_, __) => AppBootstrapState.offline,
    data: (isOnline) {
      if (!isOnline) return AppBootstrapState.offline;
      if (auth.isInitializing) return AppBootstrapState.loading;
      return AppBootstrapState.ready;
    },
  );
});
