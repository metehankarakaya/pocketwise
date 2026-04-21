import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggleVisibility() {
    state = !state;
  }

}

final dashboardProvider = NotifierProvider<DashboardNotifier, bool> (DashboardNotifier.new);
