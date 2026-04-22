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

class DateFilterNotifier extends Notifier<DateFilter?> {
  @override
  DateFilter? build() {
    return null;
  }

  void setFilter(DateFilter dateFilter) {
    state = dateFilter;
  }

  void clearFilter() {
    state = null;
  }

}

enum DateFilter {today, week, month, year}

final dashboardFilterProvider = NotifierProvider<DateFilterNotifier, DateFilter?> (DateFilterNotifier.new);
