enum ProductAvailability { inStock, limited, outOfStock }

enum ProductCategory {
  appliance('Électroménager', 'washer'),
  diy('Bricolage', 'tools'),
  electronics('Électronique', 'chip'),
  energy('Énergie', 'bolt'),
  construction('Chantier', 'hat');

  const ProductCategory(this.label, this.iconKey);

  final String label;
  final String iconKey;

  String get routeKey => switch (this) {
        ProductCategory.appliance => 'electromenager',
        ProductCategory.diy => 'bricolage',
        ProductCategory.electronics => 'electronique',
        ProductCategory.energy => 'energie',
        ProductCategory.construction => 'chantier',
      };

}

class Product {
  const Product({
    required this.id,
    required this.category,
    required this.name,
    required this.reference,
    required this.price,
    required this.availability,
    required this.iconKey,
    required this.description,
    required this.specifications,
  });

  final int id;
  final ProductCategory category;
  final String name;
  final String reference;
  final int price;
  final ProductAvailability availability;
  final String iconKey;
  final String description;
  final List<String> specifications;

  static String formatPrice(int amount) {
    final digits = amount.toString();
    final grouped = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        grouped.write(' ');
      }
      grouped.write(digits[index]);
    }
    return '$grouped FCFA';
  }
}
