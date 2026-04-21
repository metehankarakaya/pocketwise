import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pocketwise/core/providers/theme_provider.dart';
import 'package:pocketwise/features/dashboard/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ref.watch(themeModeProvider),
    );
  }
}
