import 'package:flutter_test/flutter_test.dart';

import 'package:saluz/main.dart';

void main() {
  testWidgets('App renders saLuz title', (WidgetTester tester) async {
    await tester.pumpWidget(const SaluzApp());
    expect(find.text('saLuz'), findsOneWidget);
  });
}
