import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saluz/design_system/design_system.dart';

void main() {
  Widget makeTestable(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  group('SaluzButton', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(makeTestable(
        SaluzButton(label: 'Press me', onPressed: () {}),
      ));
      expect(find.text('Press me'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(makeTestable(
        SaluzButton(
          label: 'Press me',
          onPressed: () => tapped = true,
        ),
      ));
      await tester.tap(find.text('Press me'));
      expect(tapped, isTrue);
    });

    testWidgets('shows loading indicator when isLoading', (tester) async {
      await tester.pumpWidget(makeTestable(
        SaluzButton(label: 'Press me', onPressed: () {}, isLoading: true),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Press me'), findsNothing);
    });

    testWidgets('is expanded when isExpanded', (tester) async {
      await tester.pumpWidget(makeTestable(
        SaluzButton(label: 'Wide', onPressed: () {}, isExpanded: true),
      ));
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, double.infinity);
    });

    testWidgets('shows icon when provided', (tester) async {
      await tester.pumpWidget(makeTestable(
        SaluzButton(
          label: 'With Icon',
          onPressed: () {},
          icon: Icons.add,
        ),
      ));
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });
  });

  group('SaluzCard', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(makeTestable(
        const SaluzCard(child: Text('Card content')),
      ));
      expect(find.text('Card content'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(makeTestable(
        SaluzCard(
          child: const Text('Tap me'),
          onTap: () => tapped = true,
        ),
      ));
      await tester.tap(find.text('Tap me'));
      expect(tapped, isTrue);
    });
  });

  group('SaluzAvatar', () {
    testWidgets('renders initials', (tester) async {
      await tester.pumpWidget(makeTestable(
        const SaluzAvatar(initials: 'JD'),
      ));
      expect(find.text('JD'), findsOneWidget);
    });
  });

  group('SaluzLoadingIndicator', () {
    testWidgets('renders without message', (tester) async {
      await tester.pumpWidget(makeTestable(
        const SaluzLoadingIndicator(),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders with message', (tester) async {
      await tester.pumpWidget(makeTestable(
        const SaluzLoadingIndicator(message: 'Loading data...'),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading data...'), findsOneWidget);
    });
  });
}
