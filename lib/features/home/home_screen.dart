import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/section_title.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.onOpenCategory,
    required this.onOpenProduct,
    required this.onSearch,
    required this.onHome,
    super.key,
  });

  final ValueChanged<ProductCategory> onOpenCategory;
  final ValueChanged<Product> onOpenProduct;
  final ValueChanged<String> onSearch;
  final VoidCallback onHome;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        key: const PageStorageKey('home'),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AppHeader(onHome: widget.onHome),
                _searchBox(),
                const SizedBox(height: 4),
                _presentationBanner(context),
                const SizedBox(height: 26),
                const SectionTitle('Nos univers'),
                _categoryGrid(),
                const SizedBox(height: 12),
                const SectionTitle('Produits mis en avant'),
                for (final product
                    in const ProductService().featuredProducts.take(2))
                  ProductCard(
                    product: product,
                    onTap: () => widget.onOpenProduct(product),
                  ),
                const SizedBox(height: 4),
                OutlinedButton(
                  onPressed: () =>
                      widget.onOpenCategory(ProductCategory.appliance),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.foreground,
                    side: const BorderSide(color: AppColors.line),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors.card,
                  ),
                  child: const Text(
                    'Accéder au catalogue',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
            ),
          ),
        ],
      );

  Widget _searchBox() => Container(
        height: 48,
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Color(0x08000000), blurRadius: 4),
          ],
        ),
        child: Row(
          children: [
            const AppIcon('search', color: AppColors.muted, size: 19),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: widget.onSearch,
                decoration: const InputDecoration(
                  hintText: 'Rechercher un produit…',
                  hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _presentationBanner(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.yellow, AppColors.yellowHover],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SOGAME EQUIP',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF151515),
                    fontSize: 29,
                    letterSpacing: .5,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explorez nos catégories et découvrez notre sélection de produits.',
              style: TextStyle(
                color: Color(0xFF303030),
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      );

  Widget _categoryGrid() => GridView.builder(
        itemCount: ProductCategory.values.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.45,
        ),
        itemBuilder: (context, index) {
          final category = ProductCategory.values[index];
          return Material(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => widget.onOpenCategory(category),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Color(0x08000000), blurRadius: 3),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    AppIcon(category.iconKey, color: AppColors.foreground, size: 21),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        category.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
