import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        routes: $appRoutes,
        initialLocation: '/',
      ),
    );
  }
}
