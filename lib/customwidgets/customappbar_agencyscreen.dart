import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'customtext.dart' show CustomText;
import 'custom_container.dart' show CustomContainer;

class RioliveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  // current names (images)
  final String? leftImagePath;
  final String? rightImagePath;

  // legacy aliases (old call-sites)
  final String? leftImgPath;
  final String? rightImgPath;

  // RIGHT: optional text (LEFT par text disable/ignored)
  final String? rightText;
  final TextStyle? rightTextStyle;
  final Gradient? rightTextGradient;

  // simple controls for right text size/weight
  final double? rightTextFontSize;
  final FontWeight? rightTextFontWeight;

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
    // RIGHT text
    this.rightText,
    this.rightTextStyle,
    this.rightTextGradient,
    this.rightTextFontSize,
    this.rightTextFontWeight,
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
  static const double _textHPad = 12;

  // default back image (used if no custom left image/icon provided)
  static const String _defaultBackAsset = 'assets/icons/backarrow (3).png';

  double _measureTextWidth(String text, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return tp.size.width;
  }

  @override
  Widget build(BuildContext context) {
    // ---- resolve image paths (legacy compatible) ----
    String? _leftPath;
    if ((leftImagePath ?? '').trim().isNotEmpty) {
      _leftPath = leftImagePath;
    } else if ((leftImgPath ?? '').trim().isNotEmpty) {
      _leftPath = leftImgPath;
    } else if (leftIcon == null) {
      // default back image if no custom icon
      _leftPath = _defaultBackAsset;
    }

    final String? _rightPath =
    (rightImagePath ?? '').trim().isNotEmpty
        ? rightImagePath
        : (rightImgPath ?? '').trim().isNotEmpty
        ? rightImgPath
        : null;

    final double iconSize = sideIconSize ?? 24;

    // ---- RIGHT text style compute (simple size/weight controls) ----
    final TextStyle _rightComputedStyle = rightTextStyle ??
        TextStyle(
          fontSize: rightTextFontSize ?? 16,
          fontWeight: rightTextFontWeight ?? FontWeight.w600,
          color: Colors.black87,
        );

    // ---- compute individual visual widths (no coupling) ----
    // LEFT: text ignored -> only image/icon space considered
    double leftVisualW;
    if (_leftPath != null) {
      leftVisualW = (leftImageWidth ?? 24);
    } else if (leftIcon != null) {
      leftVisualW = iconSize;
    } else {
      leftVisualW = _minTap;
    }
    final double leftSlotW = math.max(_minTap, leftVisualW);

    // RIGHT: text/image/icon supported
    double rightVisualW;
    if ((rightText ?? '').trim().isNotEmpty) {
      final w = _measureTextWidth(rightText!, _rightComputedStyle);
      rightVisualW = w + (_textHPad * 2);
    } else if (_rightPath != null) {
      rightVisualW = (rightImageWidth ?? 24);
    } else if (rightIcon != null) {
      rightVisualW = iconSize;
    } else {
      rightVisualW = _minTap;
    }
    final double rightSlotW = math.max(_minTap, rightVisualW);

    // ---- builders ----
    Widget _buildLeft({
      required String? path,
      required IconData? icon,
      required Color? tint,
      required VoidCallback? onTap,
      required double? w,
      required double? h,
      required double slotW,
    }) {
      Widget child;
      if ((path ?? '').trim().isNotEmpty) {
        child = Image.asset(
          path!,
          width: w ?? 24,
          height: h ?? 24,
          fit: BoxFit.contain,
          color: tint,
          colorBlendMode: BlendMode.srcIn,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.arrow_back, size: iconSize, color: Colors.black87),
        );
      } else if (icon != null) {
        child = Icon(icon, size: iconSize, color: tint ?? Colors.black87);
      } else {
        child = const SizedBox.shrink();
      }

      return SizedBox(
        width: slotW,
        height: _toolbarH,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Center(child: child),
          ),
        ),
      );
    }

    Widget _buildRight({
      required String? path,
      required String? text,
      required TextStyle textStyle, // already computed with size/weight
      required Gradient? textGradient,
      required IconData? icon,
      required Color? tint,
      required VoidCallback? onTap,
      required double? w,
      required double? h,
      required double slotW,
    }) {
      Widget? child;

      if ((text ?? '').trim().isNotEmpty) {
        final base = CustomText(
          text!,
          style: textStyle,
          maxLines: 1,            // <-- 1 line only
          softWrap: false,        // <-- no wrap
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        );

        final Widget wrapped = (textGradient != null)
            ? ShaderMask(
          shaderCallback: (r) => textGradient!.createShader(r),
          blendMode: BlendMode.srcIn,
          child: base,
        )
            : base;

        child = Transform.translate(          // <-- thoda left shift
          offset: const Offset(-6, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: _textHPad),
            child: wrapped,
          ),
        );
      } else if ((path ?? '').trim().isNotEmpty) {
        child = Image.asset(
          path!,
          width: w ?? 24,
          height: h ?? 24,
          fit: BoxFit.contain,
          color: tint,
          colorBlendMode: BlendMode.srcIn,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.more_horiz, size: iconSize, color: Colors.black87),
        );
      } else if (icon != null) {
        child = Icon(icon, size: iconSize, color: tint ?? Colors.black87);
      } else {
        child = const SizedBox.shrink();
      }

      return SizedBox(
        width: slotW,
        height: _toolbarH,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Center(child: child),
          ),
        ),
      );
    }

    Widget _titleWidget() {
      if ((title ?? '').isEmpty) return const SizedBox.shrink();

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
            style: TextStyle(fontSize: fs, fontWeight: fw, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
          ),
        );
      }

      return CustomText(
        title!,
        style: TextStyle(fontSize: fs, fontWeight: fw, color: col),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        textAlign: TextAlign.center,
      );
    }

    // ---- Layout with Stack: keeps title centered without wasting space ----
    return CustomContainer(
      conColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: _toolbarH,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Centered title, padded so it doesn't overlap side widgets
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: math.max(leftSlotW, rightSlotW),
                ),
                child: Center(child: _titleWidget()),
              ),

              // Sides layered above/below
              Positioned.fill(
                child: Row(
                  children: [
                    _buildLeft(
                      path: _leftPath,
                      icon: leftIcon,
                      tint: leftImageColor,
                      onTap: onLeftPressed ?? () => Get.back(),
                      w: leftImageWidth,
                      h: leftImageHeight,
                      slotW: leftSlotW,
                    ),
                    const Spacer(),
                    _buildRight(
                      path: _rightPath,
                      text: rightText,
                      textStyle: _rightComputedStyle,
                      textGradient: rightTextGradient,
                      icon: rightIcon,
                      tint: rightImageColor,
                      onTap: onRightPressed,
                      w: rightImageWidth,
                      h: rightImageHeight,
                      slotW: rightSlotW,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
