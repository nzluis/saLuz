import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saluz/main.dart';

void main() {
  testWidgets('App renders saLuz title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SaluzApp()),
    );
    expect(find.text('saLuz'), findsOneWidget);
  });
}
