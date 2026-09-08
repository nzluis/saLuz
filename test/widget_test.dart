import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:saluz/core/router/app_router.dart';
import 'package:saluz/l10n/app_localizations.dart';

void main() {
  testWidgets('HomeScreen renders localized text in Spanish', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es')],
        home: const HomeScreen(),
      ),
    );
    expect(find.text('saLuz'), findsNWidgets(2));
    expect(find.text('Contenido Educativo'), findsOneWidget);
    expect(find.text('Consulta Médica'), findsOneWidget);
  });

  testWidgets('ContentScreen renders localized text in Spanish', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es')],
        home: const ContentScreen(),
      ),
    );
    expect(find.text('Contenido'), findsOneWidget);
    expect(find.text('Contenido Educativo'), findsOneWidget);
  });

  testWidgets('ConsultationScreen renders localized text in Spanish', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es')],
        home: const ConsultationScreen(),
      ),
    );
    expect(find.text('Consulta'), findsOneWidget);
    expect(find.text('Consulta Médica'), findsOneWidget);
  });
}
