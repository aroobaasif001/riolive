import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? conColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final DecorationImage? image;
  final BoxBorder? border;
  final BoxShape shape;
  final AlignmentGeometry? alignment;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  // 🔹 Added new props
  final VoidCallback? onTap;     // for simple tap
  final VoidCallback? onPressed; // alias for button-style usage

  const CustomContainer({
    super.key,
    this.height,
    this.width,
    this.conColor,
    this.borderRadius,
    this.child,
    this.image,
    this.border,
    this.shape = BoxShape.rectangle,
    this.alignment,
    this.boxShadow,
    this.gradient,
    this.margin,
    this.padding,
    this.onTap,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final container = Container(
      padding: padding,
      margin: margin,
      alignment: alignment,
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: gradient,
        image: image,
        color: conColor,
        borderRadius: borderRadius,
        shape: shape,
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );

    // agar onTap / onPressed diya gaya ho, to tappable banao
    if (onTap != null || onPressed != null) {
      return GestureDetector(
        onTap: onTap ?? onPressed,
        child: container,
      );
    }

    return container;
  }
}
