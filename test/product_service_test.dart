import 'package:flutter_test/flutter_test.dart';
import 'package:sogame_equip/models/product.dart';
import 'package:sogame_equip/services/product_service.dart';

void main() {
  const service = ProductService();

  group('ProductService', () {
    test('filters products by category and case-insensitive query', () {
      final products = service.productsFor(
        ProductCategory.appliance,
        query: 'ref-rf',
      );

      expect(products, hasLength(1));
      expect(products.single.name, 'Réfrigérateur combiné');
    });

    test('returns an empty list when no product matches', () {
      expect(
        service.productsFor(ProductCategory.electronics),
        isEmpty,
      );
      expect(
        service.productsFor(ProductCategory.diy, query: 'introuvable'),
        isEmpty,
      );
    });

    test('searches across catalog categories', () {
      final products = service.searchProducts('REF-SC');

      expect(products, hasLength(1));
      expect(products.single.category, ProductCategory.diy);
    });
  });

  test('formats FCFA prices with French thousands separators', () {
    expect(Product.formatPrice(170000), '170 000 FCFA');
    expect(Product.formatPrice(8000), '8 000 FCFA');
  });
}
