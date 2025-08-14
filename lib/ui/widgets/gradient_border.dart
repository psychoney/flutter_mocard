import 'package:flutter/material.dart';

class GradientBorder extends InputBorder {
  final Gradient gradient;
  final double borderWidth;
  final BorderRadius borderRadius;

  GradientBorder({
    required this.gradient,
    this.borderWidth = 2.0,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  bool get isOutline => true; // 添加 isOutline getter

  @override
  InputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
  }) {
    return GradientBorder(
      gradient: gradient,
      borderWidth: borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderWidth);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect).deflate(borderWidth));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection? textDirection,
      double? gapStart,
      double? gapExtent = 0.0,
      double? gapPercentage = 0.0,
      TextBaseline? textBaseline}) {
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return GradientBorder(
      gradient: gradient,
      borderWidth: borderWidth * t,
      borderRadius: borderRadius * t,
    );
  }
}
