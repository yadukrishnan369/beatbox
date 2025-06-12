import 'package:flutter/widgets.dart';

typedef VoidCallback = void Function();

class AppLifecycleHandler extends WidgetsBindingObserver {
  final VoidCallback onRequireBiometric;
  final VoidCallback onAppPaused;

  AppLifecycleHandler({
    required this.onRequireBiometric,
    required this.onAppPaused,
  });

  // called when app lifecycle state changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      onRequireBiometric();
    }
  }
}
