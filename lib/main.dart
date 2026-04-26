import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pocketwise/core/providers/theme_provider.dart';
import 'package:pocketwise/features/dashboard/screens/dashboard_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pocketwise/features/security/providers/security_provider.dart';
import 'package:pocketwise/features/security/screens/pin_screen.dart';

import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await NotificationService.initialize();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale("en", "US"),
        Locale("de"),
        Locale("es"),
        Locale("tr")
      ],
      saveLocale: true,
      path: "assets/translations",
      fallbackLocale: Locale("en", "US"),
      child: ProviderScope(child: const MyApp()),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLockEnabled = ref.watch(securityProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: isLockEnabled ? PinScreen(mode: PinMode.verify) : const DashboardScreen(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ref.watch(themeModeProvider),
    );
  }
}
