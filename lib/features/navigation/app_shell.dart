import 'package:flutter/material.dart';

import '../../core/widgets/app_background.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../catalog/catalog_screen.dart';
import '../home/home_screen.dart';
import '../product_details/product_detail_screen.dart';
import '../quote/quote_screen.dart';
import 'category_dock.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var _isHome = true;
  var _category = ProductCategory.appliance;
  var _query = '';
  Product? _product;
  var _isQuote = false;

  void _openHome() {
    setState(() {
      _isHome = true;
      _product = null;
      _isQuote = false;
      _query = '';
    });
  }

  void _openCategory(ProductCategory category, {String query = ''}) {
    setState(() {
      _isHome = false;
      _category = category;
      _query = query;
      _product = null;
      _isQuote = false;
    });
  }

  void _openProduct(Product product) {
    setState(() {
      _isHome = false;
      _category = product.category;
      _product = product;
      _isQuote = false;
    });
  }

  void _openQuote() => setState(() => _isQuote = true);

  void _returnToProduct() => setState(() => _isQuote = false);

  void _searchFromHome(String query) {
    final matches = const ProductService().searchProducts(query);
    final matchingProduct = matches.isEmpty ? null : matches.first;

    _openCategory(
      matchingProduct?.category ?? ProductCategory.appliance,
      query: query,
    );
  }

  Future<bool> _handleBack() async {
    if (_isQuote) {
      _returnToProduct();
      return false;
    }
    if (_product != null) {
      _openCategory(_product!.category);
      return false;
    }
    if (!_isHome) {
      _openHome();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Widget screen;
    if (_isHome) {
      screen = HomeScreen(
        key: const ValueKey('home'),
        onOpenCategory: _openCategory,
        onOpenProduct: _openProduct,
        onSearch: _searchFromHome,
        onHome: _openHome,
      );
    } else if (_isQuote && _product != null) {
      screen = QuoteScreen(
        key: ValueKey('quote-${_product!.id}'),
        product: _product!,
        onHome: _openHome,
        onBack: _returnToProduct,
      );
    } else if (_product != null) {
      screen = ProductDetailScreen(
        key: ValueKey('product-${_product!.id}'),
        product: _product!,
        onHome: _openHome,
        onBack: () => _openCategory(_product!.category),
        onRequestQuote: _openQuote,
      );
    } else {
      screen = CatalogScreen(
        key: ValueKey('catalog-${_category.routeKey}'),
        category: _category,
        initialQuery: _query,
        onHome: _openHome,
        onOpenProduct: _openProduct,
      );
    }

    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        body: AppBackground(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SafeArea(
                bottom: false,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: screen,
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: CategoryDock(
          activeCategory: _isHome ? null : _category,
          onSelect: _openCategory,
        ),
      ),
    );
  }
}
