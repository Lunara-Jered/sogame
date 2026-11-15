import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/section_title.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({
    required this.category,
    required this.initialQuery,
    required this.onHome,
    required this.onOpenProduct,
    super.key,
  });

  final ProductCategory category;
  final String initialQuery;
  final VoidCallback onHome;
  final ValueChanged<Product> onOpenProduct;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  static const _service = ProductService();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  var _searchVisible = false;
  var _query = '';

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _controller.text = _query;
    _searchVisible = _query.isNotEmpty;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searchVisible = !_searchVisible;
      if (!_searchVisible) {
        _query = '';
        _controller.clear();
      }
    });
    if (_searchVisible) _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final products = _service.productsFor(widget.category, query: _query);
    final categoryHasProducts =
        _service.productsFor(widget.category).isNotEmpty;

    return CustomScrollView(
      key: PageStorageKey('catalog-${widget.category.routeKey}'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AppHeader(onHome: widget.onHome, onSearch: _toggleSearch),
              if (_searchVisible) _searchField(),
              SectionTitle(widget.category.label),
              if (products.isEmpty)
                _emptyState(
                  categoryHasProducts: categoryHasProducts,
                  query: _query,
                )
              else
                for (final product in products)
                  ProductCard(
                    product: product,
                    onTap: () => widget.onOpenProduct(product),
                  ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _searchField() => Container(
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
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Rechercher un produit…',
                  hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _emptyState({
    required bool categoryHasProducts,
    required String query,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 56),
        child: Column(
          children: [
            const AppIcon('box', size: 40, color: AppColors.muted),
            const SizedBox(height: 14),
            Text(
              categoryHasProducts ? 'Aucun résultat' : 'Bientôt disponible',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              categoryHasProducts
                  ? 'Aucun produit ne correspond à « $query ».'
                  : 'De nouveaux produits arrivent prochainement dans cette catégorie.',
              style: const TextStyle(color: AppColors.muted, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}
