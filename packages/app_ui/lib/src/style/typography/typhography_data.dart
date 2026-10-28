part of 'typhography.dart';

class TyphographyItem {
  final double fontSize;
  final double lineHeight;

  TyphographyItem({required this.fontSize, required this.lineHeight});
}

class TyphographyData {
  final String? fontFamily;
  final TextStyle xs;
  final TextStyle sm;
  final TextStyle base;
  final TextStyle lg;
  final TextStyle xl;
  final TextStyle xl2;
  final TextStyle xl3;
  final TextStyle xl4;
  final TextStyle xl5;
  final TextStyle xl6;
  final TextStyle xl7;
  final TextStyle xl8;
  final TextStyle xl9;
  final TextStyle heading1;
  final TextStyle heading2;
  final TextStyle heading3;
  final TextStyle heading4;
  final TextStyle heading5;
  final TextStyle body;
  final TextStyle small;
  final TextStyle footNote;

  static TextStyle _build(
    TyphographyItem typhographyItem,
    String? fontFamily,
  ) => TextStyle(
    fontSize: typhographyItem.fontSize,
    fontFamily: fontFamily,
    height: typhographyItem.lineHeight / typhographyItem.fontSize,
  );

  const TyphographyData({
    required this.fontFamily,
    required this.xs,
    required this.sm,
    required this.base,
    required this.lg,
    required this.xl,
    required this.xl2,
    required this.xl3,
    required this.xl4,
    required this.xl5,
    required this.xl6,
    required this.xl7,
    required this.xl8,
    required this.xl9,
    required this.heading1,
    required this.heading2,
    required this.heading3,
    required this.heading4,
    required this.body,
    required this.small,
    required this.footNote,
    required this.heading5,
  });

  TyphographyData copyWith({
    String? fontFamily,
    TyphographyItem? xs,
    TyphographyItem? sm,
    TyphographyItem? base,
    TyphographyItem? lg,
    TyphographyItem? xl,
    TyphographyItem? xl2,
    TyphographyItem? xl3,
    TyphographyItem? xl4,
    TyphographyItem? xl5,
    TyphographyItem? xl6,
    TyphographyItem? xl7,
    TyphographyItem? xl8,
    TyphographyItem? xl9,
    TyphographyItem? heading1,
    TyphographyItem? heading2,
    TyphographyItem? heading3,
    TyphographyItem? heading4,
    TyphographyItem? heading5,
    TyphographyItem? body,
    TyphographyItem? small,
    TyphographyItem? footNote,
  }) => TyphographyData(
    fontFamily: fontFamily ?? fontFamily,
    xs: xs != null ? _build(xs, fontFamily) : this.xs,
    sm: sm != null ? _build(sm, fontFamily) : this.sm,
    base: base != null ? _build(base, fontFamily) : this.base,
    lg: lg != null ? _build(lg, fontFamily) : this.lg,
    xl: xl != null ? _build(xl, fontFamily) : this.xl,
    xl2: xl2 != null ? _build(xl2, fontFamily) : this.xl2,
    xl3: xl3 != null ? _build(xl3, fontFamily) : this.xl3,
    xl4: xl4 != null ? _build(xl4, fontFamily) : this.xl4,
    xl5: xl5 != null ? _build(xl5, fontFamily) : this.xl5,
    xl6: xl6 != null ? _build(xl6, fontFamily) : this.xl6,
    xl7: xl7 != null ? _build(xl7, fontFamily) : this.xl7,
    xl8: xl8 != null ? _build(xl8, fontFamily) : this.xl8,
    xl9: xl9 != null ? _build(xl9, fontFamily) : this.xl9,
    small: small != null ? _build(small, fontFamily) : this.small,
    body: body != null ? _build(body, fontFamily) : this.body,
    footNote: footNote != null ? _build(footNote, fontFamily) : this.footNote,
    heading1: heading1 != null ? _build(heading1, fontFamily) : this.heading1,
    heading2: heading2 != null ? _build(heading2, fontFamily) : this.heading2,
    heading3: heading3 != null ? _build(heading3, fontFamily) : this.heading3,
    heading4: heading4 != null ? _build(heading4, fontFamily) : this.heading4,
    heading5: heading5 != null ? _build(heading5, fontFamily) : this.heading5,
  );

  factory TyphographyData.minimum({
    String? fontFamily,
    required TyphographyItem xs,
    required TyphographyItem sm,
    required TyphographyItem base,
    required TyphographyItem lg,
    required TyphographyItem xl,
    required TyphographyItem xl2,
    required TyphographyItem xl3,
    required TyphographyItem xl4,
    required TyphographyItem xl5,
    required TyphographyItem xl6,
    required TyphographyItem xl7,
    required TyphographyItem xl8,
    required TyphographyItem xl9,
    required TyphographyItem heading1,
    required TyphographyItem heading2,
    required TyphographyItem heading3,
    required TyphographyItem heading4,
    required TyphographyItem heading5,
    required TyphographyItem body,
    required TyphographyItem small,
    required TyphographyItem footNote,
  }) => TyphographyData(
    fontFamily: fontFamily,
    xs: _build(xs, fontFamily),
    sm: _build(sm, fontFamily),
    base: _build(base, fontFamily),
    lg: _build(lg, fontFamily),
    xl: _build(xl, fontFamily),
    xl2: _build(xl2, fontFamily),
    xl3: _build(xl3, fontFamily),
    xl4: _build(xl4, fontFamily),
    xl5: _build(xl5, fontFamily),
    xl6: _build(xl6, fontFamily),
    xl7: _build(xl7, fontFamily),
    xl8: _build(xl8, fontFamily),
    xl9: _build(xl9, fontFamily),
    small: _build(small, fontFamily),
    body: _build(body, fontFamily),
    footNote: _build(footNote, fontFamily),
    heading1: _build(heading1, fontFamily),
    heading2: _build(heading2, fontFamily),
    heading3: _build(heading3, fontFamily),
    heading4: _build(heading4, fontFamily),
    heading5: _build(heading5, fontFamily),
  );
}
