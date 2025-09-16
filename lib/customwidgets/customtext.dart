import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppFont { instrumentSans, lora, poppins }

class CustomText extends StatelessWidget {
  final String text;

  // Styling
  final AppFont fontType;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final double? letterSpacing;
  final double? lineHeight;
  final FontStyle? fontStyle;
  final List<Shadow>? shadows; // optional
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;
  final TextDecorationStyle? decorationStyle;
  final Color? backgroundColor;
  final TextStyle? style;

  // Layout
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final EdgeInsets? padding;

  // Extras
  final TextDirection? textDirection;
  final Locale? locale;
  final double? textScaleFactor;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final String? semanticsLabel;


  const CustomText(
      this.text, {
        super.key,
        this.fontType = AppFont.instrumentSans,
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
        this.textDirection,
        this.locale,
        this.textScaleFactor,
        this.strutStyle,
        this.textWidthBasis,
        this.textHeightBehavior,
        this.semanticsLabel,
      });

  @override
  Widget build(BuildContext context) {
    final baseStyle = DefaultTextStyle.of(context).style;

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
        shadows: shadows, // no default shadow
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
        decorationStyle: decorationStyle,
        backgroundColor: backgroundColor,
      ),
    )
        .merge(style);

    // ✅ Safe defaults to prevent yellow overflow stripes
// ✅ Safe defaults same as Flutter Text widget
    final int? effectiveMaxLines = maxLines; // null means unlimited lines
    final TextOverflow? effectiveOverflow = overflow; // null means default clip
    final bool? effectiveSoftWrap = softWrap; // null means default true


    final textWidget = Text(
      text,
      style: mergedStyle,
      textAlign: textAlign,
      maxLines: effectiveMaxLines,
      overflow: effectiveOverflow,
      softWrap: effectiveSoftWrap,
      textDirection: textDirection,
      locale: locale,
      textScaleFactor: textScaleFactor,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      semanticsLabel: semanticsLabel,
    );


    if (padding == null || padding == EdgeInsets.zero) return textWidget;
    return Padding(padding: padding!, child: textWidget);
  }
}
