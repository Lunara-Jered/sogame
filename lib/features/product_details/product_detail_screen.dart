import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_icon.dart';
import '../../core/widgets/availability_chip.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    required this.product,
    required this.onHome,
    required this.onBack,
    required this.onRequestQuote,
    super.key,
  });

  final Product product;
  final VoidCallback onHome;
  final VoidCallback onBack;
  final VoidCallback onRequestQuote;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        key: PageStorageKey('product-${product.id}'),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AppHeader(onHome: onHome),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: onBack,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.foreground,
                      padding: const EdgeInsets.fromLTRB(0, 2, 8, 14),
                    ),
                    icon: const AppIcon('back', size: 19),
                    label: Text(product.category.label),
                  ),
                ),
                _gallery(context),
                _detailsCard(context),
                const SizedBox(height: 8),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: onRequestQuote,
                    icon: const AppIcon('phone', size: 19, color: Colors.black),
                    label: const Text('Demander un devis'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: const BorderSide(
                        color: AppColors.foreground,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.foreground,
                    side: const BorderSide(color: AppColors.line),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continuer mes achats',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Préparez votre demande de devis. Elle ne sera pas envoyée depuis cette application.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      );

  Widget _gallery(BuildContext context) {
    final width =
        MediaQuery.sizeOf(context).width.clamp(0.0, 480.0).toDouble() - 32;
    return SizedBox(
      height: width * .82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) => Container(
          width: width * .82,
          decoration: BoxDecoration(
            color: index == 0 ? AppColors.yellow : AppColors.soft,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: AppIcon(
            product.iconKey,
            size: 76,
            color: index == 0 ? const Color(0xFF151515) : AppColors.muted,
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _detailsCard(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x08000000), blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 25,
                    height: 1.1,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Réf. ${product.reference}',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    Product.formatPrice(product.price),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'TTC',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              product.description,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.line),
            const SizedBox(height: 16),
            for (final specification in product.specifications)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 7, right: 14),
                      decoration: const BoxDecoration(
                        color: AppColors.yellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        specification,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: AppColors.line),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Disponibilité',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AvailabilityChip(product.availability),
                ],
              ),
            ),
          ],
        ),
      );
}
