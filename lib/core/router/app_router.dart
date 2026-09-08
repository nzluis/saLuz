import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.homeTitle,
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton.tonal(
              onPressed: () => const ContentRoute().go(context),
              child: Text(l10n.educationalContent),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.tonal(
              onPressed: () => const ConsultationRoute().go(context),
              child: Text(l10n.medicalConsultation),
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.contentScreenTitle)),
      body: Center(
        child: Text(l10n.contentScreenBody),
      ),
    );
  }
}

class ConsultationScreen extends StatelessWidget {
  const ConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.consultationScreenTitle)),
      body: Center(
        child: Text(l10n.consultationScreenBody),
      ),
    );
  }
}
