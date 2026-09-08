import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'design_system/design_system.dart';
import 'l10n/app_localizations.dart';

void main() {
  configureDependencies();
  runApp(const ProviderScope(child: SaluzApp()));
}

class SaluzApp extends ConsumerWidget {
  const SaluzApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'saLuz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      routerConfig: GoRouter(
        routes: $appRoutes,
        initialLocation: '/',
      ),
    );
  }
}
