import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sogame_equip/features/catalog/catalog_screen.dart';
import 'package:sogame_equip/features/home/home_screen.dart';
import 'package:sogame_equip/features/navigation/app_shell.dart';
import 'package:sogame_equip/features/navigation/category_dock.dart';
import 'package:sogame_equip/models/product.dart';

void main() {
  testWidgets(
    'keeps page content visible with the dock and opens every catalog category',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AppShell()));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(CategoryDock), findsOneWidget);
      expect(find.text('Nos univers'), findsOneWidget);

      for (final category in ProductCategory.values) {
        await tester.tap(find.bySemanticsLabel(category.label).first);
        await tester.pumpAndSettle();

        expect(find.byType(CatalogScreen), findsOneWidget);
        expect(find.byType(CategoryDock), findsOneWidget);
        expect(find.text(category.label), findsWidgets);
        if (category == ProductCategory.appliance) {
          expect(find.text('Réfrigérateur combiné'), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      }
    },
  );
}
