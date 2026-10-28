// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'icons.dart';

class AppIcon extends StatelessWidget {
  final AppIcons icon;
  final double? width;
  final double? height;
  final Color? color;

  const AppIcon(this.icon, {super.key, this.width, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    final color = this.color;
    if (icon._isDualTone && color != null) {
      return FutureBuilder<String>(
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return SvgPicture.string(
              snapshot.data!,
              width: width,
              height: height,
            );
          }
          if (snapshot.hasError) {
            SvgPicture.asset(
              icon._path,
              width: width,
              height: height,
              package: 'app_ui',
            );
          }
          return const SizedBox();
        },
        future: () async {
          String svgCode = await rootBundle.loadString(
            "packages/app_ui/${icon._path}",
          );
          svgCode = svgCode.replaceAll(
            // ignore: deprecated_member_use
            "#8533D6",
            // ignore: deprecated_member_use
            '#${color.value.toRadixString(16)}',
          );

          return svgCode;
        }(),
      );
    }
    return SvgPicture.asset(
      icon._path,
      width: width,
      package: 'app_ui',
      height: height,
      // ignore: deprecated_member_use
      color: color,
    );
  }
}


typedef NTIIcon = AppIcon;
typedef NTIIcons = AppIcons;
