import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_ui/src/style/styles.dart';

class NTIAppBar extends AppBar {
  NTIAppBar({
    required BuildContext context,
    super.key,
    super.leading,
    Widget? title,
    super.actions,
    double? elevation,
    super.flexibleSpace,
    Color? foregroundColor,
    String? titleText,
    super.iconTheme,
    super.actionsIconTheme,
    Color? backgroundColor,
    TextStyle? titleTextStyle,
    Color? statusBarColor,
    super.centerTitle = true,
  }) : super(
         title: title ?? (titleText != null ? Text(titleText) : null),
         titleTextStyle:
             titleTextStyle ??
             const TextStyle(
               color: Color(0xff262626),
               fontSize: 20,
               fontFamily: 'Inter',
               fontWeight: FontWeight.bold,
             ),
         elevation: elevation ?? 1,
         backgroundColor: backgroundColor ?? Colors.white,
         foregroundColor: foregroundColor ?? Colors.black,
         systemOverlayStyle:
             Platform.isAndroid
                 ? SystemUiOverlayStyle.light.copyWith(
                   statusBarColor: context.colorTheme.brandTeal10Reverse,
                 )
                 : null,
       );
}
