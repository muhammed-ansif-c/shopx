import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  final controller = StreamController<bool>();

  final subscription = Connectivity().onConnectivityChanged.listen((result) {
    controller.add(result != ConnectivityResult.none);
  });

  ref.onDispose(() => subscription.cancel());

  return controller.stream;
});
//tells your app: internet ON or OFF