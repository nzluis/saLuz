import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saluz/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SaluzApp()),
    );
    await tester.pumpAndSettle();
    expect(find.text('saLuz'), findsNWidgets(2));
    expect(find.text('Contenido Educativo'), findsOneWidget);
    expect(find.text('Consulta Médica'), findsOneWidget);
  });
}
