import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppFont { instrumentSans, lora, poppins } // Added poppins to the enum

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

    // Added Poppins to the font selection logic
    TextStyle googleFont;
    switch (fontType) {
      case AppFont.lora:
        googleFont = GoogleFonts.lora();
        break;
      case AppFont.poppins:
        googleFont = GoogleFonts.poppins();
        break;
      case AppFont.instrumentSans:
      default:
        googleFont = GoogleFonts.instrumentSans();
        break;
    }

    final mergedStyle = baseStyle
        .merge(
          googleFont.copyWith(
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
