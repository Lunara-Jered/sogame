import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_icon.dart';
import '../../models/product.dart';

class CategoryDock extends StatelessWidget {
  const CategoryDock({
    required this.activeCategory,
    required this.onSelect,
    super.key,
  });

  final ProductCategory? activeCategory;
  final ValueChanged<ProductCategory> onSelect;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: 78 + bottomInset,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Container(
            height: 78 + bottomInset,
            decoration: const BoxDecoration(
              color: AppColors.dock,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x38000000),
                  blurRadius: 20,
                  offset: Offset(0, -6),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(8, 8, 8, bottomInset + 2),
            child: Row(
              children: [
                for (final category in ProductCategory.values)
                  Expanded(
                    child: _DockItem(
                      category: category,
                      active: activeCategory == category,
                      onTap: () => onSelect(category),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.category,
    required this.active,
    required this.onTap,
  });

  final ProductCategory category;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        selected: active,
        label: category.label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 65,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -25,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: active ? AppColors.yellow : Colors.transparent,
                      shape: BoxShape.circle,
                      border: active
                          ? Border.all(color: AppColors.dock, width: 5)
                          : null,
                      boxShadow: active
                          ? const [
                              BoxShadow(
                                color: Color(0x38000000),
                                blurRadius: 12,
                                offset: Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    offset: active ? const Offset(0, -.85) : Offset.zero,
                    child: AppIcon(
                      category.iconKey,
                      size: 22,
                      color: active ? const Color(0xFF151515) : const Color(0xFF96969D),
                      strokeWidth: 1.9,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 3,
                  left: 0,
                  right: 0,
                  child: Text(
                    category.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: active ? AppColors.yellow : const Color(0xFF96969D),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
