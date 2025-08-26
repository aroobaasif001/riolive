import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppFont { instrumentSans, lora }

class CustomText extends StatelessWidget {
  final String text;
  final AppFont fontType;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? lineHeight;
  final TextDecoration? decoration;
  final TextStyle? style;
  final EdgeInsets? padding;
  final bool? softWrap;
  final FontStyle? fontStyle;
  final List<Shadow>? shadows;
  final Color? decorationColor;
  final double? decorationThickness;
  final TextDecorationStyle? decorationStyle;
  final Color? backgroundColor;

  const CustomText(
    this.text, {
    super.key,
    this.fontType = AppFont.instrumentSans, // Default font
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.lineHeight,
    this.decoration,
    this.style,
    this.padding,
    this.softWrap,
    this.fontStyle,
    this.shadows,
    this.decorationColor,
    this.decorationThickness,
    this.decorationStyle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = DefaultTextStyle.of(context).style;

    final googleFont = fontType == AppFont.lora ? GoogleFonts.lora : GoogleFonts.instrumentSans;

    final mergedStyle = baseStyle
        .merge(
          googleFont(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            letterSpacing: letterSpacing,
            height: lineHeight,
            fontStyle: fontStyle,
            shadows: shadows,
            decoration: decoration,
            decorationColor: decorationColor,
            decorationThickness: decorationThickness,
            decorationStyle: decorationStyle,
            backgroundColor: backgroundColor,
          ),
        )
        .merge(style);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        text,
        style: mergedStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
      ),
    );
  }
}
