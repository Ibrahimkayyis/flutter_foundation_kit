// Colors

import 'package:flutter/material.dart';

part 'color_provider.dart';
part 'colors/accent.dart';
part 'colors/basic.dart';
part 'colors/system.dart';
part 'colors/teal.dart';
part 'color_example.dart';

class ColorTheme {
  final ColorBasic basic;
  final ColorPrimary primary;
  final ColorAccent accent;
  final ColorSystem system;

  const ColorTheme({
    required this.basic,
    required this.primary,
    required this.accent,
    required this.system,
  });

  Color get basic1 => basic.shade12;
  Color get basic2 => basic.shade11;
  Color get basic3 => basic.shade10;
  Color get basic4 => basic.shade9;
  Color get basic5 => basic.shade8;
  Color get basic6 => basic.shade7;
  Color get basic7 => basic.shade6;
  Color get basic8 => basic.shade5;
  Color get basic9 => basic.shade4;
  Color get basic10 => basic.shade3;
  Color get basic11 => basic.shade2;
  Color get basic12 => basic.shade1;

  Color get primary1 => primary.shade12;
  Color get primary2 => primary.shade11;
  Color get primary3 => primary.shade10;
  Color get primary4 => primary.shade9;
  Color get primary5 => primary.shade8;
  Color get primary6 => primary.shade7;
  Color get primary7 => primary.shade6;
  Color get primary8 => primary.shade5;
  Color get primary9 => primary.shade4;
  Color get primary10 => primary.shade3;
  Color get primary11 => primary.shade2;
  Color get primary12 => primary.shade1;

  Color get accent1 => accent.shade12;
  Color get accent2 => accent.shade11;
  Color get accent3 => accent.shade10;
  Color get accent4 => accent.shade9;
  Color get accent5 => accent.shade8;
  Color get accent6 => accent.shade7;
  Color get accent7 => accent.shade6;
  Color get accent8 => accent.shade5;
  Color get accent9 => accent.shade4;
  Color get accent10 => accent.shade3;
  Color get accent11 => accent.shade2;
  Color get accent12 => accent.shade1;

  Color get brandTeal10 => primary10;
  Color get brandTeal8 => primary8;
  Color get brandTeal12 => primary12;

  Color get brandAccent10 => accent10;
  Color get brandAccent8 => accent8;
  Color get brandAccent3 => accent3;

  Color get basic1Reverse => basic.shade1;

  Color get basic2Reverse => basic.shade2;

  Color get basic3Reverse => basic.shade3;

  Color get basic4Reverse => basic.shade4;

  Color get basic5Reverse => basic.shade5;

  Color get basic6Reverse => basic.shade6;

  Color get basic7Reverse => basic.shade7;

  Color get basic8Reverse => basic.shade8;

  Color get basic9Reverse => basic.shade9;

  Color get basic10Reverse => basic.shade10;

  Color get basic11Reverse => basic.shade11;

  Color get basic12Reverse => basic.shade12;

  Color get primary1Reverse => primary.shade1;

  Color get primary2Reverse => primary.shade2;

  Color get primary3Reverse => primary.shade3;

  Color get primary4Reverse => primary.shade4;

  Color get primary5Reverse => primary.shade5;

  Color get primary6Reverse => primary.shade6;

  Color get primary7Reverse => primary.shade7;

  Color get primary8Reverse => primary.shade8;

  Color get primary9Reverse => primary.shade9;

  Color get primary10Reverse => primary.shade10;

  Color get primary11Reverse => primary.shade11;

  Color get primary12Reverse => primary.shade12;

  Color get primary13Reverse => primary.shade13;

  Color get primary14Reverse => primary.shade14;

  Color get accent1Reverse => accent.shade1;

  Color get accent2Reverse => accent.shade2;

  Color get accent3Reverse => accent.shade3;

  Color get accent4Reverse => accent.shade4;

  Color get accent5Reverse => accent.shade5;

  Color get accent6Reverse => accent.shade6;

  Color get accent7Reverse => accent.shade7;

  Color get accent8Reverse => accent.shade8;

  Color get accent9Reverse => accent.shade9;

  Color get accent10Reverse => accent.shade10;

  Color get accent11Reverse => accent.shade11;

  Color get accent12Reverse => accent.shade12;

  Color get brandTeal10Reverse => primary10Reverse;

  Color get brandTeal8Reverse => primary8Reverse;

  Color get brandTeal12Reverse => primary12Reverse;

  Color get brandAccent10Reverse => accent10Reverse;

  Color get brandAccent8Reverse => accent8Reverse;

  Color get brandAccent3Reverse => accent3Reverse;

  Color get brandBasic10Reverse => basic10Reverse;

  Color get systemLink => system.link;

  Color get systemDanger => system.danger;

  Color get systemDangerLight => system.dangerLight;

  Color get systemWarning => system.warning;

  Color get systemWarningLight => system.warningLight;

  Color get systemSuccess => system.success;

  Color get systemSuccessLight => system.successLight;
}
