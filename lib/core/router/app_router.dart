import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'app_router.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ContentRoute>(path: 'content'),
    TypedGoRoute<ConsultationRoute>(path: 'consultation'),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

class ContentRoute extends GoRouteData with $ContentRoute {
  const ContentRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ContentScreen();
  }
}

class ConsultationRoute extends GoRouteData with $ConsultationRoute {
  const ConsultationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConsultationScreen();
  }
}

// Placeholder screens — will be replaced in Phase 4 and 7
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('saLuz')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'saLuz',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.tonal(
              onPressed: () => const ContentRoute().go(context),
              child: const Text('Contenido Educativo'),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => const ConsultationRoute().go(context),
              child: const Text('Consulta Médica'),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contenido')),
      body: const Center(
        child: Text('Contenido Educativo'),
      ),
    );
  }
}

class ConsultationScreen extends StatelessWidget {
  const ConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta')),
      body: const Center(
        child: Text('Consulta Médica'),
      ),
    );
  }
}
