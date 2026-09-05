import 'package:biblitos/app.dart';
import 'package:biblitos/providers/sky_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BiblitosApp — sky toggle', () {
    testWidgets('defaults to day and shows the moon icon', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: BiblitosApp()));
      await tester.pump();

      expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
      expect(find.byIcon(Icons.wb_sunny), findsNothing);
    });

    testWidgets('tapping the toggle switches to night and shows the sun icon', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const BiblitosApp(),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.nightlight_round));
      await tester.pump();

      expect(container.read(skyProvider), true);
      expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
      expect(find.byIcon(Icons.nightlight_round), findsNothing);
    });
  });
}
