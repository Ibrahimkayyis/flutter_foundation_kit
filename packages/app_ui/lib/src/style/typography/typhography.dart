import 'dart:ui' as ui;

import 'package:flutter/material.dart';

part 'typhography_data.dart';

class TyphographyProvider extends StatelessWidget {
  final TyphographyData typhographyData;
  final Widget child;
  const TyphographyProvider({
    super.key,
    required this.typhographyData,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TyphographyScope(textData: typhographyData, child: child);
  }
}

class TyphographyScope extends InheritedWidget {
  final TyphographyData textData;
  const TyphographyScope({
    super.key,
    required this.textData,
    required super.child,
  });

  static TyphographyScope of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<TyphographyScope>();
    if (widget == null) {
      throw Exception("Cant Found Typhography Provider in the tree");
    }
    return widget;
  }

  @override
  bool updateShouldNotify(TyphographyScope oldWidget) {
    return oldWidget.textData != textData;
  }
}

extension CtxTyphographyExt on BuildContext {
  TyphographyScope get colorScope => TyphographyScope.of(this);

  TyphographyData get text => TyphographyScope.of(this).textData;
}

extension TextStyleExt on TextStyle {
  TextStyle applyTyphography(TyphographyItem typhographyItem) => copyWith(
    height: typhographyItem.lineHeight,
    fontSize: typhographyItem.fontSize,
  );

  TyphographyItem get typhography =>
      TyphographyItem(fontSize: fontSize ?? 0, lineHeight: height ?? 0);

  TextStyle get w100 => copyWith(fontWeight: FontWeight.w100);
  TextStyle get w200 => copyWith(fontWeight: FontWeight.w200);
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);
  TextStyle get w900 => copyWith(fontWeight: FontWeight.w500);

  TextStyle get bold => w600;
  TextStyle get medium => w500;
  TextStyle get normal => w400;

  TextStyle applyColor(Color color) => copyWith(color: color);

  TextStyle copyWithTyphography(
    TyphographyItem typhographyItem, {
    bool? inherit,
    Color? color,
    Color? backgroundColor,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    ui.TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<ui.Shadow>? shadows,
    List<ui.FontFeature>? fontFeatures,
    List<ui.FontVariation>? fontVariations,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
  }) => copyWith(
    background: background,
    backgroundColor: backgroundColor,
    color: color,
    debugLabel: debugLabel,
    decoration: decoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
    decorationThickness: decorationThickness,
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontFeatures: fontFeatures,
    fontSize: typhographyItem.fontSize,
    fontStyle: fontStyle,
    fontVariations: fontVariations,
    fontWeight: fontWeight,
    foreground: foreground,
    height: typhographyItem.lineHeight,
    inherit: inherit,
    leadingDistribution: leadingDistribution,
    letterSpacing: letterSpacing,
    locale: locale,
    overflow: overflow,
    package: package,
    shadows: shadows,
    textBaseline: textBaseline,
    wordSpacing: wordSpacing,
  );
}
