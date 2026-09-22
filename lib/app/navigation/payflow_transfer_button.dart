import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class PayflowTransferButton extends StatelessWidget {
  final String label;
  final double collapseProgress;
  final VoidCallback onTap;

  const PayflowTransferButton({
    super.key,
    required this.label,
    required this.collapseProgress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = collapseProgress.clamp(0.0, 1.0).toDouble();
    final double labelOpacity = (1 - progress / .62)
        .clamp(0.0, 1.0)
        .toDouble();
    final height = lerpDouble(35, 48, progress)!;
    final horizontalPadding = lerpDouble(10, 10.5, progress)!;
    final iconSize = lerpDouble(25, 27, progress)!;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(height / 2),
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A00),
              borderRadius: BorderRadius.circular(height / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .16),
                  blurRadius: lerpDouble(15, 18, progress)!,
                  offset: Offset(0, lerpDouble(5, 6, progress)!),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: math.pi * .5 * progress,
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
                SizedBox(width: 9 * labelOpacity),
                ClipRect(
                  child: Align(
                    widthFactor: labelOpacity,
                    child: Opacity(
                      opacity: labelOpacity,
                      child: Text(
                        label,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
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
    );
  }
}
