import 'dart:ui';

import 'package:flutter/material.dart';

class PayflowNavigationItem {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;

  const PayflowNavigationItem({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
  });
}

class PayflowBottomNavigation extends StatelessWidget {
  static const Color _selectedColor = Color(0xFF008B80);
  static const Color _unselectedColor = Color(0xFF302C2A);

  final int selectedIndex;
  final double collapseProgress;
  final List<PayflowNavigationItem> items;
  final ValueChanged<int> onSelected;
  final VoidCallback onExpand;

  const PayflowBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.collapseProgress,
    required this.items,
    required this.onSelected,
    required this.onExpand,
  }) : assert(items.length > 1);

  @override
  Widget build(BuildContext context) {
    final progress = collapseProgress.clamp(0.0, 1.0);
    final height = lerpDouble(64, 15, progress)!;
    final labelOpacity = (1 - progress / .42).clamp(0.0, 1.0);
    final iconOpacity = (1 - ((progress - .38) / .54)).clamp(0.0, 1.0);
    final handleOpacity = ((progress - .72) / .28).clamp(0.0, 1.0);
    final radius = lerpDouble(38, 10, progress)!;

    return Semantics(
      container: true,
      child: SizedBox(
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: lerpDouble(.08, .12, progress)!,
                ),
                blurRadius: lerpDouble(28, 14, progress)!,
                offset: Offset(0, lerpDouble(8, 4, progress)!),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Material(
                color: Colors.white.withValues(
                  alpha: lerpDouble(.58, .78, progress)!,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    IgnorePointer(
                      ignoring: progress >= .78,
                      child: Opacity(
                        opacity: iconOpacity > labelOpacity
                            ? iconOpacity
                            : labelOpacity,
                        child: Row(
                          children: [
                            for (var index = 0; index < items.length; index++)
                              Expanded(
                                child: _NavigationItemView(
                                  item: items[index],
                                  selected: selectedIndex == index,
                                  collapseProgress: progress,
                                  labelOpacity: labelOpacity,
                                  iconOpacity: iconOpacity,
                                  onTap: () => onSelected(index),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    IgnorePointer(
                      ignoring: progress < .72,
                      child: Opacity(
                        opacity: handleOpacity,
                        child: Semantics(
                          button: true,
                          label: items[selectedIndex].label,
                          child: InkWell(
                            onTap: onExpand,
                            splashFactory: NoSplash.splashFactory,
                            child: Center(
                              child: Container(
                                width: 34,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: _selectedColor,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItemView extends StatelessWidget {
  final PayflowNavigationItem item;
  final bool selected;
  final double collapseProgress;
  final double labelOpacity;
  final double iconOpacity;
  final VoidCallback onTap;

  const _NavigationItemView({
    required this.item,
    required this.selected,
    required this.collapseProgress,
    required this.labelOpacity,
    required this.iconOpacity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const selectedColor = PayflowBottomNavigation._selectedColor;
    const unselectedColor = PayflowBottomNavigation._unselectedColor;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFF0F3F2).withValues(
                      alpha: 1 - collapseProgress,
                    )
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(28),
            ),
            child: OverflowBox(
              minHeight: 64,
              maxHeight: 64,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: iconOpacity,
                    child: AnimatedScale(
                      scale: selected ? 1.06 : 1,
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutBack,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: Icon(
                          selected ? item.selectedIcon : item.unselectedIcon,
                          key: ValueKey(selected),
                          size: 23,
                          color: selected ? selectedColor : unselectedColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3 * labelOpacity),
                  ClipRect(
                    child: Align(
                      heightFactor: labelOpacity,
                      child: Opacity(
                        opacity: labelOpacity,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOut,
                          style: TextStyle(
                            color: selected
                                ? selectedColor
                                : unselectedColor,
                            fontSize: 10.5,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
