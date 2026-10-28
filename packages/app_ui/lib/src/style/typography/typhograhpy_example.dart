import 'package:flutter/material.dart';
import 'package:app_ui/src/style/typography/typhography.dart';

extension _NumExt on num {
  double px(BuildContext context) => this / 1;
}

TyphographyData typhoGraphy(context) => TyphographyData.minimum(
  xs: TyphographyItem(fontSize: 12.px(context), lineHeight: 16.px(context)),
  sm: TyphographyItem(fontSize: 14.px(context), lineHeight: 20.px(context)),
  base: TyphographyItem(fontSize: 16.px(context), lineHeight: 24.px(context)),
  lg: TyphographyItem(fontSize: 18.px(context), lineHeight: 28.px(context)),
  xl: TyphographyItem(fontSize: 20.px(context), lineHeight: 28.px(context)),
  xl2: TyphographyItem(fontSize: 24.px(context), lineHeight: 32.px(context)),
  xl3: TyphographyItem(fontSize: 30.px(context), lineHeight: 36.px(context)),
  xl4: TyphographyItem(fontSize: 36.px(context), lineHeight: 40.px(context)),
  xl5: TyphographyItem(fontSize: 48.px(context), lineHeight: 48.px(context)),
  xl6: TyphographyItem(fontSize: 60.px(context), lineHeight: 60.px(context)),
  xl7: TyphographyItem(fontSize: 72.px(context), lineHeight: 72.px(context)),
  xl8: TyphographyItem(fontSize: 96.px(context), lineHeight: 96.px(context)),
  xl9: TyphographyItem(fontSize: 128.px(context), lineHeight: 128.px(context)),
  heading1: TyphographyItem(
    fontSize: 46.px(context),
    lineHeight: 54.px(context),
  ),
  heading2: TyphographyItem(
    fontSize: 38.px(context),
    lineHeight: 46.px(context),
  ),
  heading3: TyphographyItem(
    fontSize: 30.px(context),
    lineHeight: 38.px(context),
  ),
  heading4: TyphographyItem(
    fontSize: 24.px(context),
    lineHeight: 32.px(context),
  ),
  heading5: TyphographyItem(
    fontSize: 20.px(context),
    lineHeight: 28.px(context),
  ),
  body: TyphographyItem(fontSize: 16.px(context), lineHeight: 24.px(context)),
  small: TyphographyItem(fontSize: 14.px(context), lineHeight: 22.px(context)),
  footNote: TyphographyItem(
    fontSize: 12.px(context),
    lineHeight: 20.px(context),
  ),
);
