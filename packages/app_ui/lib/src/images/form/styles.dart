part of 'image_form.dart';

typedef NTIImagePickerBuilderFunc =
    Widget Function(
      BuildContext context,
      NTIImage? image,
      VoidCallback onImageClick,
      VoidCallback onRemoveImage,
      VoidCallback onPickImage,
    );

typedef NTIImagePickerImagePickedBuilder =
    Widget Function(
      BuildContext context,
      NTIImage image,
      VoidCallback onImageClick,
    );

abstract class NTIImagePickerStyle {
  static NTIImagePickerAvatar avatar({
    String? extraTitle,
    double radius = 72,
  }) => NTIImagePickerAvatar(extraText: extraTitle, radius: radius);

  const NTIImagePickerStyle();
  Widget build(
    BuildContext context,
    NTIImage? image,
    VoidCallback onImageClick,
    VoidCallback onRemoveImage,
    VoidCallback onPickImage,
  );
}

class NTIImagePickerSmallRectangle implements NTIImagePickerStyle {
  final Size? size;
  final Size? iconSize;
  final String? addText;
  final Widget Function(BuildContext context, VoidCallback onPickImage)?
  emptyBuilder;

  NTIImagePickerSmallRectangle({
    this.size,
    this.addText,
    this.emptyBuilder,
    this.iconSize,
  });

  @override
  Widget build(
    BuildContext context,
    NTIImage? image,
    VoidCallback onImageClick,
    VoidCallback onRemoveImage,
    VoidCallback onPickImage,
  ) {
    if (image == null) {
      return emptyBuilder?.call(context, onPickImage) ??
          SizedBox(
            width: size?.width ?? 48,
            height: size?.height ?? 48,
            child: _MultipleImageAddButton(
              onPickImage: onPickImage,
              addText: addText,
            ),
          );
    }
    return InkWell(
      onTap: onImageClick,
      child: Stack(
        children: [
          Container(
            width: size?.width ?? 48,
            height: size?.height ?? 48,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(128),
                  spreadRadius: .1,
                  blurRadius: 6,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(image: image.provider, fit: BoxFit.cover),
            ),
          ),
          Container(
            width: size?.width ?? 48,
            height: size?.height ?? 48,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.2 * 255).round()),
                  spreadRadius: .1,
                  blurRadius: 6,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: AppIcon(
                AppIcons.edit,
                color: context.colorTheme.basic1,
                height: iconSize?.height ?? ((size?.width ?? 48) * 2 / 5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NTIImagePickerCustom implements NTIImagePickerStyle {
  final NTIImagePickerBuilderFunc builder;

  NTIImagePickerCustom({required this.builder});

  @override
  Widget build(
    BuildContext context,
    NTIImage? image,
    VoidCallback onImageClick,
    VoidCallback onRemoveImage,
    VoidCallback onPickImage,
  ) => build.call(context, image, onImageClick, onRemoveImage, onPickImage);
}

class NTIImagePickerRectangle implements NTIImagePickerStyle {
  final Size? imageSize;
  final Size? pickerSize;
  final Widget? content;
  final NTIImagePickerImagePickedBuilder? pickedBuilder;

  NTIImagePickerRectangle({
    this.imageSize,
    this.pickerSize,
    this.content,
    this.pickedBuilder,
  });

  @override
  Widget build(
    BuildContext context,
    NTIImage? image,
    VoidCallback onImageClick,
    VoidCallback onRemoveImage,
    VoidCallback onPickImage,
  ) {
    if (image != null) {
      return pickedBuilder?.call(context, image, onImageClick) ??
          InkWell(
            onTap: onImageClick,
            child: Image(
              image: image.provider,
              height: imageSize?.height,
              width: imageSize?.width,
            ),
          );
    }
    return InkWell(
      onTap: onPickImage,
      child: Container(
        decoration: BoxDecoration(color: context.colorTheme.basic2Reverse),
        width: pickerSize?.width ?? double.infinity,
        height: pickerSize?.height,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(8),
          color: context.colorTheme.basic7,
          strokeWidth: 1,
          dashPattern: const [6, 3],
          child: Container(
            child:
                content ??
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Ketuk untuk upload",
                      style: context.text.base.copyWith(
                        color: context.colorTheme.basic8,
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

class NTIImagePickerAvatar implements NTIImagePickerStyle {
  final String? extraText;
  final double radius;
  final Color? backgroundColor;
  final NTIImagePickerBuilderFunc? emptyBuilder;

  const NTIImagePickerAvatar({
    this.extraText,
    this.radius = 72,
    this.emptyBuilder,
    this.backgroundColor,
  });

  @override
  Widget build(
    BuildContext context,
    NTIImage? image,
    VoidCallback onImageClick,
    VoidCallback onRemoveImage,
    VoidCallback onPickImage,
  ) {
    final color = context.colorTheme;
    final decoration = BoxDecoration(
      shape: BoxShape.circle,
      color: color.basic4,
    );
    final emptyBuilder = this.emptyBuilder;
    return Column(
      children: [
        Container(
          width: radius,
          height: radius,
          decoration: decoration.copyWith(
            color: backgroundColor ?? color.basic4,
            image:
                image != null
                    ? DecorationImage(image: image.provider, fit: BoxFit.cover)
                    : null,
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onImageClick,
            child:
                (image == null && emptyBuilder != null)
                    ? emptyBuilder(
                      context,
                      image,
                      onImageClick,
                      onRemoveImage,
                      onPickImage,
                    )
                    : Ink(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: image == null ? const _AddImage() : null,
                    ),
          ),
        ),
        if (extraText != null)
          InkWell(
            onTap: onPickImage,
            child: Text(
              extraText!,
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
