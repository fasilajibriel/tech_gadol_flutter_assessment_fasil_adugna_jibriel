import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/category_chip.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/error_state_widget.dart';

void main() {
  group('CategoryChip', () {
    testWidgets('renders label and triggers callback on tap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              label: 'Smartphones',
              isSelected: false,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Smartphones'), findsOneWidget);

      await tester.tap(find.text('Smartphones'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('ErrorStateWidget', () {
    testWidgets('shows message and retry button when retry is provided', (
      tester,
    ) async {
      var retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              message: 'Something failed',
              onRetry: () {
                retried = true;
              },
              retryLabel: 'Try again',
            ),
          ),
        ),
      );

      expect(find.text('Something failed'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pump();

      expect(retried, isTrue);
    });

    testWidgets('compact mode renders as TextButton only', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(message: 'Compact error', compact: true),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('Compact error'), findsOneWidget);
    });
  });
}
