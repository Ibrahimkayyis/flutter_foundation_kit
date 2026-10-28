/// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsErrorGen {
  const $AssetsErrorGen();

  SvgGenImage get error402Large =>
      const SvgGenImage('assets/error/Error-402 - Large.svg');
  SvgGenImage get error402Small =>
      const SvgGenImage('assets/error/Error-402 - Small.svg');
  SvgGenImage get error403Large =>
      const SvgGenImage('assets/error/Error-403 - Large.svg');
  SvgGenImage get error403Small =>
      const SvgGenImage('assets/error/Error-403 - Small.svg');
  SvgGenImage get error404Large =>
      const SvgGenImage('assets/error/Error-404 - Large.svg');
  SvgGenImage get error404Small =>
      const SvgGenImage('assets/error/Error-404 - Small.svg');
  SvgGenImage get error408Large =>
      const SvgGenImage('assets/error/Error-408 - Large.svg');
  SvgGenImage get error408Small =>
      const SvgGenImage('assets/error/Error-408 - Small.svg');
  SvgGenImage get error413Large =>
      const SvgGenImage('assets/error/Error-413 - Large.svg');
  SvgGenImage get error413Small =>
      const SvgGenImage('assets/error/Error-413 - Small.svg');
  SvgGenImage get error500Large =>
      const SvgGenImage('assets/error/Error-500 - Large.svg');
  SvgGenImage get error500Small =>
      const SvgGenImage('assets/error/Error-500 - Small.svg');
  SvgGenImage get error502Large =>
      const SvgGenImage('assets/error/Error-502 - Large.svg');
  SvgGenImage get error502Small =>
      const SvgGenImage('assets/error/Error-502 - Small.svg');
  SvgGenImage get error503Large =>
      const SvgGenImage('assets/error/Error-503 - Large.svg');
  SvgGenImage get error503Small =>
      const SvgGenImage('assets/error/Error-503 - Small.svg');
  SvgGenImage get errorFailedToSendLarge =>
      const SvgGenImage('assets/error/Error-Failed-to-send - Large.svg');
  SvgGenImage get errorFailedToSendSmall =>
      const SvgGenImage('assets/error/Error-Failed-to-send - Small.svg');
  SvgGenImage get errorUnknownLarge =>
      const SvgGenImage('assets/error/Error-Unknown - Large.svg');
  SvgGenImage get errorConnectionLarge =>
      const SvgGenImage('assets/error/Error-connection - Large.svg');
  SvgGenImage get errorConnectionSmall =>
      const SvgGenImage('assets/error/Error-connection - Small.svg');
  SvgGenImage get errorUnknownSmall =>
      const SvgGenImage('assets/error/Error-unknown - Small.svg');
  SvgGenImage get error402Unauthorized =>
      const SvgGenImage('assets/error/error-402-unauthorized.svg');
  SvgGenImage get error403AccessDenied =>
      const SvgGenImage('assets/error/error-403-access-denied.svg');
  SvgGenImage get error404NotFound =>
      const SvgGenImage('assets/error/error-404-not-found.svg');
  SvgGenImage get error408Timeout =>
      const SvgGenImage('assets/error/error-408-timeout.svg');
  SvgGenImage get error413TooLarge =>
      const SvgGenImage('assets/error/error-413-too-large.svg');
  SvgGenImage get error500 => const SvgGenImage('assets/error/error-500.svg');
  SvgGenImage get error502 => const SvgGenImage('assets/error/error-502.svg');
  SvgGenImage get error503 => const SvgGenImage('assets/error/error-503.svg');
  SvgGenImage get errorConnection =>
      const SvgGenImage('assets/error/error-connection.svg');
  SvgGenImage get errorFailedToSend =>
      const SvgGenImage('assets/error/error-failed-to-send.svg');
  SvgGenImage get errorUnknown =>
      const SvgGenImage('assets/error/error-unknown.svg');
}

class Assets {
  const Assets._();

  static const String package = 'app_ui';
  static const $AssetsErrorGen error = $AssetsErrorGen();
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  static const String package = 'app_ui';

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package = package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/app_ui/$_assetName';
}
