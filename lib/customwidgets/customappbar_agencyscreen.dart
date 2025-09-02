import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'customtext.dart' show CustomText;
import 'custom_container.dart' show CustomContainer;

class RioliveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  // current names
  final String? leftImagePath;
  final String? rightImagePath;

  // legacy aliases (old call-sites)
  final String? leftImgPath;
  final String? rightImgPath;

  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;

  final double? leftImageHeight;
  final double? leftImageWidth;
  final double? rightImageHeight;
  final double? rightImageWidth;

  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final Color? titleColor;
  final Gradient? titleGradient;

  // optional tint / icons
  final Color? leftImageColor;
  final Color? rightImageColor;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final double? sideIconSize;

  const RioliveAppBar({
    Key? key,
    this.title,
    this.leftImagePath,
    this.rightImagePath,
    this.leftImgPath,   // legacy
    this.rightImgPath,  // legacy
    this.onLeftPressed,
    this.onRightPressed,
    this.leftImageHeight,
    this.leftImageWidth,
    this.rightImageHeight,
    this.rightImageWidth,
    this.titleFontSize,
    this.titleFontWeight,
    this.titleColor,
    this.titleGradient,
    this.leftImageColor,
    this.rightImageColor,
    this.leftIcon,
    this.rightIcon,
    this.sideIconSize,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  static const double _toolbarH = 56;
  static const double _minTap = 44;

  // ✅ default back image (used if no custom left image/icon provided)
  static const String _defaultBackAsset = 'assets/icons/backarrow (3).png';

  @override
  Widget build(BuildContext context) {
    // ---- resolve left path (defaults to back image if nothing passed) ----
    String? _leftPath;
    if (leftImagePath != null && leftImagePath!.trim().isNotEmpty) {
      _leftPath = leftImagePath;
    } else if (leftImgPath != null && leftImgPath!.trim().isNotEmpty) {
      _leftPath = leftImgPath;
    } else if (leftIcon == null) {
      _leftPath = _defaultBackAsset; // default
    }

    // ---- resolve right path (no default) ----
    final String? _rightPath =
    (rightImagePath != null && rightImagePath!.trim().isNotEmpty)
        ? rightImagePath
        : (rightImgPath != null && rightImgPath!.trim().isNotEmpty)
        ? rightImgPath
        : null;

    final double leftW  = leftImageWidth  ?? 24;
    final double rightW = rightImageWidth ?? 24;
    final double sideSlotWidth = math.max(_minTap, math.max(leftW, rightW));
    final double iconSize = sideIconSize ?? 24;

    Widget side({
      required String? path,
      required IconData? icon,
      required Color? tint,
      required VoidCallback? onTap,
      required double? w,
      required double? h,
      required IconData fallback,
    }) {
      Widget? child;
      if (path != null && path.trim().isNotEmpty) {
        child = Image.asset(
          path,
          width: w ?? 24,
          height: h ?? 24,
          fit: BoxFit.contain,
          color: tint,                // tint helps white PNGs on light bg
          colorBlendMode: BlendMode.srcIn,
          errorBuilder: (_, __, ___) => Icon(fallback, size: iconSize, color: Colors.black87),
        );
      } else if (icon != null) {
        child = Icon(icon, size: iconSize, color: tint ?? Colors.black87);
      }

      return SizedBox(
        width: sideSlotWidth,
        height: _toolbarH,
        child: child == null
            ? const SizedBox.shrink()
            : InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(child: child),
        ),
      );
    }

    Widget titleWidget() {
      if (title == null || title!.isEmpty) return const SizedBox.shrink();

      final double fs = titleFontSize ?? 20;
      final FontWeight fw = titleFontWeight ?? FontWeight.bold;
      final Color col = titleColor ?? Colors.black;

      if (titleGradient != null) {
        return ShaderMask(
          shaderCallback: (b) =>
              titleGradient!.createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
          blendMode: BlendMode.srcIn,
          child: CustomText(
            title!,
            fontSize: fs,
            fontWeight: fw,
            color: Colors.black, // base for gradient mask
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
          ),
        );
      }

      return CustomText(
        title!,
        color: col,
        fontWeight: fw,
        fontSize: fs,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        textAlign: TextAlign.center,
      );
    }

    return CustomContainer(
      conColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: _toolbarH,
          child: Row(
            children: [
              // LEFT – default back image + Get.back()
              side(
                path: _leftPath,
                icon: leftIcon,
                tint: leftImageColor,
                onTap: onLeftPressed ?? () => Get.back(), // 👈 uses GetX
                w: leftImageWidth,
                h: leftImageHeight,
                fallback: Icons.arrow_back,
              ),

              Expanded(child: Center(child: titleWidget())),

              // RIGHT – only shows if you pass path/icon
              side(
                path: _rightPath,
                icon: rightIcon,
                tint: rightImageColor,
                onTap: onRightPressed,
                w: rightImageWidth,
                h: rightImageHeight,
                fallback: Icons.more_horiz,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
