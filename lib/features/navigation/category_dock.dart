import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_icon.dart';
import '../../models/product.dart';

class CategoryDock extends StatefulWidget {
  const CategoryDock({
    required this.activeCategory,
    required this.onSelect,
    super.key,
  });

  final ProductCategory? activeCategory;
  final ValueChanged<ProductCategory> onSelect;

  @override
  State<CategoryDock> createState() => _CategoryDockState();
}

class _CategoryDockState extends State<CategoryDock>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 300);
  static const _dockHeight = 64.0;
  static const _pillHeight = 48.0;
  static const _inactiveItemWidth = 38.0;

  late final AnimationController _pillController;
  Rect? _currentPillRect;
  Rect? _fromPillRect;
  var _disableAnimations = false;

  @override
  void initState() {
    super.initState();
    _pillController = AnimationController(vsync: this, duration: _duration);
  }

  @override
  void didUpdateWidget(covariant CategoryDock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeCategory == widget.activeCategory) return;

    _fromPillRect = _currentPillRect;
    if (widget.activeCategory == null) {
      _pillController.stop();
      _currentPillRect = null;
    } else if (_disableAnimations) {
      _pillController.value = 1;
    } else {
      _pillController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pillController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    if (disableAnimations &&
        !_disableAnimations &&
        _pillController.isAnimating) {
      _pillController.value = 1;
    }
    _disableAnimations = disableAnimations;
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.viewInsetsOf(context).bottom > 0) {
      return const SizedBox.shrink();
    }

    final itemDuration = _disableAnimations ? Duration.zero : _duration;

    return Container(
      color: AppColors.dock,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: _dockHeight,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final categories = ProductCategory.values;
                      final activeCategory = widget.activeCategory;
                      final activeIndex = activeCategory == null
                          ? -1
                          : categories.indexOf(activeCategory);
                      final contentWidth = constraints.maxWidth;
                      final itemWidths = _itemWidths(contentWidth, activeIndex);
                      final itemRects = _itemRects(contentWidth, itemWidths);
                      final activeRect = activeIndex < 0
                          ? null
                          : Rect.fromLTWH(
                              itemRects[activeIndex].left,
                              (_dockHeight - _pillHeight) / 2,
                              itemRects[activeIndex].width,
                              _pillHeight,
                            );

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          if (activeRect != null)
                            AnimatedBuilder(
                              animation: _pillController,
                              builder: (context, child) {
                                final rect = _pillRect(activeRect);
                                _currentPillRect = rect;
                                return Positioned.fromRect(
                                  rect: rect,
                                  child: child!,
                                );
                              },
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x26000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          for (var index = 0;
                              index < categories.length;
                              index++)
                            AnimatedPositioned.fromRect(
                              key: ValueKey(categories[index]),
                              rect: itemRects[index],
                              duration: itemDuration,
                              curve: Curves.easeOutCubic,
                              child: _DockItem(
                                category: categories[index],
                                active: index == activeIndex,
                                reduceMotion: _disableAnimations,
                                onTap: () => widget.onSelect(categories[index]),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<double> _itemWidths(double availableWidth, int activeIndex) {
    final categories = ProductCategory.values;
    final widths = List<double>.filled(
      categories.length,
      _inactiveItemWidth,
    );
    if (activeIndex < 0) return widths;

    final category = categories[activeIndex];
    final textPainter = TextPainter(
      text: TextSpan(
        text: category.label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();

    final desiredWidth = textPainter.width + 20 + 6 + 14;
    final maxActiveWidth = math.max(
      0.0,
      availableWidth - _inactiveItemWidth * (categories.length - 1),
    );
    widths[activeIndex] = math.min(desiredWidth, maxActiveWidth);
    return widths;
  }

  List<Rect> _itemRects(double availableWidth, List<double> widths) {
    final totalWidth = widths.fold<double>(0, (sum, width) => sum + width);
    final gap = widths.length > 1
        ? math.max(0.0, (availableWidth - totalWidth) / (widths.length - 1))
        : 0.0;
    var left = 0.0;
    return widths.map((width) {
      final rect = Rect.fromLTWH(left, 0, width, _dockHeight);
      left += width + gap;
      return rect;
    }).toList(growable: false);
  }

  Rect _pillRect(Rect target) {
    final from = _fromPillRect;
    if (from == null || !_pillController.isAnimating) return target;

    final progress = Curves.easeOutCubic.transform(_pillController.value);
    final rect = Rect.lerp(from, target, progress)!;
    final deltaX = target.center.dx - from.center.dx;
    final distance = deltaX.abs();
    final direction = deltaX.sign;
    final stretch =
        math.min(8.0, distance * 0.06) * math.sin(math.pi * progress);
    return Rect.fromLTRB(
      rect.left - stretch * (direction < 0 ? .75 : .25),
      rect.top,
      rect.right + stretch * (direction > 0 ? .75 : .25),
      rect.bottom,
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.category,
    required this.active,
    required this.reduceMotion,
    required this.onTap,
  });

  final ProductCategory category;
  final bool active;
  final bool reduceMotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 220);
    final iconColor =
        active ? const Color(0xFF151515) : const Color(0xFF96969D);

    return Semantics(
      button: true,
      selected: active,
      label: category.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: ClipRect(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: active ? 1.12 : 1,
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  child: TweenAnimationBuilder<Color?>(
                    tween: ColorTween(end: iconColor),
                    duration: duration,
                    builder: (context, color, child) => AppIcon(
                      category.iconKey,
                      size: 20,
                      color: color ?? iconColor,
                      strokeWidth: 1.9,
                    ),
                  ),
                ),
                Flexible(
                  child: AnimatedSize(
                    duration: duration,
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.centerLeft,
                    child: AnimatedSwitcher(
                      duration: duration,
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(.12, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: active
                          ? Padding(
                              key: ValueKey(category),
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                category.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF151515),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(key: ValueKey('inactive')),
                    ),
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
