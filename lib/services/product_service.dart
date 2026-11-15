import '../data/mock_products.dart';
import '../models/product.dart';

class ProductService {
  const ProductService();

  List<Product> productsFor(ProductCategory category, {String query = ''}) {
    final normalizedQuery = query.trim().toLowerCase();
    return mockProducts.where((product) {
      final matchesCategory = product.category == category;
      final matchesQuery = normalizedQuery.isEmpty ||
          '${product.name} ${product.reference}'
              .toLowerCase()
              .contains(normalizedQuery);
      return matchesCategory && matchesQuery;
    }).toList(growable: false);
  }

  List<Product> searchProducts(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return const [];
    return mockProducts
        .where(
          (product) => '${product.name} ${product.reference}'
              .toLowerCase()
              .contains(normalizedQuery),
        )
        .toList(growable: false);
  }

  List<Product> get featuredProducts => mockProducts;
}
