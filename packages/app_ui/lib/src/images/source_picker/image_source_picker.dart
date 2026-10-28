import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_ui/src/buttons/button.dart';
import 'package:app_ui/src/icon/index.dart';
import 'package:app_ui/src/images/image_picker_util.dart';
import 'package:app_ui/src/layout/index.dart';
import 'package:app_ui/src/style/styles.dart';

class NTIImageSourceWidget extends StatelessWidget {
  final String? title;
  final VoidCallback? onRemove;
  const NTIImageSourceWidget({super.key, this.title, this.onRemove});

  static Future<NTIImageSource?> launch(
    BuildContext context, {
    String? title,
    VoidCallback? onRemove,
  }) async {
    final source = await showModalBottomSheet(
      context: context,
      shape: NTIBottomSheet.basicBorder(),
      builder:
          (context) => NTIBottomSheet(
            builder: (context, header) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    12.verticalSpace,
                    header,
                    14.verticalSpace,
                    NTIImageSourceWidget(title: title, onRemove: onRemove),
                  ],
                ),
              );
            },
          ),
    );
    if (source is! NTIImageSource) return null;
    return source;
  }

  Widget backButton(BuildContext context) {
    return _ImageSourceButton(
      iconData: AppIcons.arrowLeft,
      onTap: () => Navigator.of(context).maybePop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              backButton(context),
              Expanded(
                child: Text(
                  title ?? "Pilih Gambar",
                  textAlign: TextAlign.center,
                  style: context.text.base.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onRemove == null)
                NTIHideWidget(child: backButton(context))
              else
                _ImageSourceButton(
                  iconData: AppIcons.delete,
                  onTap: () => onRemove?.call(),
                ),
            ],
          ),
          24.verticalSpace,
          AppDefaultButton(
            text: "Pilih dari album",
            leftIcon: const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.photo),
            ),
            onPressed:
                () => Navigator.of(context).maybePop(NTIImageSource.gallery),
            isFillParent: true,
          ),
          18.verticalSpace,
          AppOutlinedButton(
            text: "Ambil Foto",
            leftIcon: const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.camera_alt_outlined),
            ),
            onPressed:
                () => Navigator.of(context).maybePop(NTIImageSource.camera),
            isFillParent: true,
          ),
          MediaQuery.of(context).padding.bottom.verticalSpace,
        ],
      ),
    );
  }
}

class _ImageSourceButton extends StatelessWidget {
  final AppIcons iconData;
  final VoidCallback onTap;
  const _ImageSourceButton({required this.iconData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colorTheme.basic1,
        boxShadow: [
          BoxShadow(
            color: context.colorTheme.basic4Reverse,
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, .5), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(onTap: () => onTap(), child: AppIcon(iconData, width: 20)),
    );
  }
}
