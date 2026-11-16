import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sogame_equip/features/navigation/category_dock.dart';
import 'package:sogame_equip/models/product.dart';

void main() {
  testWidgets(
    'keeps category selection and shows only its label',
    (tester) async {
      var activeCategory = ProductCategory.appliance;

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 320,
              child: StatefulBuilder(
                builder: (context, setState) => Scaffold(
                  bottomNavigationBar: CategoryDock(
                    activeCategory: activeCategory,
                    onSelect: (category) {
                      setState(() => activeCategory = category);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final category in ProductCategory.values) {
        await tester.tap(find.bySemanticsLabel(category.label).first);
        await tester.pumpAndSettle();

        expect(activeCategory, category);
        for (final candidate in ProductCategory.values) {
          expect(
            find.text(candidate.label),
            candidate == category ? findsOneWidget : findsNothing,
          );
        }
        expect(tester.takeException(), isNull);
      }
    },
  );
}
