import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../constants/app_colors.dart';

class AvailabilityChip extends StatelessWidget {
  const AvailabilityChip(this.availability, {super.key});

  final ProductAvailability availability;

  @override
  Widget build(BuildContext context) {
    final (label, foreground, background) = switch (availability) {
      ProductAvailability.inStock => (
          'En stock',
          AppColors.success,
          AppColors.successSoft
        ),
      ProductAvailability.limited => (
          'Stock limité',
          AppColors.limited,
          AppColors.limitedSoft
        ),
      ProductAvailability.outOfStock => (
          'Épuisé',
          AppColors.unavailable,
          AppColors.unavailableSoft
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: foreground, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
