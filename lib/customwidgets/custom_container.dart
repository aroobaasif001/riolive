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
  final bgImagePath;
  final iconPath;
  final label;
  final onTap;
  String ?title;
  final subTitle;
  final decoration;

   CustomContainer({super.key,
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
    this.bgImagePath,
    this.iconPath,
    this.label,
    this.title,
     this.subTitle,
     this.decoration,
     this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin:margin ,
      alignment: alignment,
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient:gradient,
        image: image,
        color: conColor,
        borderRadius: borderRadius,
        shape: shape,
        border: border,
        boxShadow: boxShadow
      ),
      child: child,
    );
  }
}