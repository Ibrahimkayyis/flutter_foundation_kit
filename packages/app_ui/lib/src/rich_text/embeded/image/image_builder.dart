part of 'embeded_image.dart';

class NTIImageEmbedBuilder extends EmbedBuilder {
  final String baseUrl;
  final ImageErrorWidgetBuilder? imageErrorWidgetBuilder;
  NTIImageEmbedBuilder({this.imageErrorWidgetBuilder, this.baseUrl = ""});

  @override
  String get key => NTIImage.className;

  @override
  bool get expanded => false;

  Image getQuillImageByUrl(
    NTIImage data, {
    required String baseurl,
    required ImageErrorWidgetBuilder? imageErrorWidgetBuilder,
    double? width,
    double? height,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    if (data is NTIMemoryImage && data.filepath != null) {
      return Image.file(
        File(data.filepath!),
        gaplessPlayback: true,
        width: width,
        height: height,
        alignment: alignment,
      );
    }
    return Image(
      image: data.provider,
      width: width,
      height: height,
      gaplessPlayback: true,
      alignment: alignment,
      errorBuilder: imageErrorWidgetBuilder,
    );
  }

  void _onTap(
    BuildContext context, {
    required QuillController controller,
    required NTIImage imageData,
    required bool readOnly,
  }) {
    if (readOnly) {
      _onReadOnlyTap(context, controller: controller, imageData: imageData);
      return;
    }
    _onEditTap(context, controller: controller, imageData: imageData);
  }

  void _onReadOnlyTap(
    BuildContext context, {
    required QuillController controller,
    required NTIImage imageData,
  }) {
    final (images, initialIndex) = _findLinesByKey(controller, imageData.name);
    NTIImagesCarousel.showAsDialog(
      context,
      initialIndex: initialIndex,
      images: images.map((e) => e.provider).toList(),
    );
  }

  void _onEditTap(
    BuildContext context, {
    required QuillController controller,
    required NTIImage imageData,
  }) async {
    final result = await NTIImageEditor.launch(
      context,
      cropConfig: NTICropConfig(cropStyle: NTICropStyle.rectanlge),
      initialImage: imageData,
    );
    if (result == null) return;
    final offset = getEmbedNode(controller, controller.selection.start).offset;
    final newElement = switch (result) {
      NTIImageEditorResultDelete() => '',
      NTIImageEditorResultNewImage() => await NTIImageEmbeded.fromFile(
        File(result.image.filepath),
      ),
    };
    controller.replaceText(
      offset,
      1,
      newElement,
      TextSelection.collapsed(offset: offset),
    );
  }

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    try {
      final data = embedContext.node.value.data;
      if (data == null) return const SizedBox();
      final imageData = NTIImage.fromJSON(
        data is String ? jsonDecode(data) : data,
      );

      final image = getQuillImageByUrl(
        imageData,
        baseurl: baseUrl,
        imageErrorWidgetBuilder: imageErrorWidgetBuilder,
      );

      return InkWell(
        onTap:
            () => _onTap(
              context,
              controller: embedContext.controller,
              imageData: imageData,
              readOnly: embedContext.readOnly,
            ),
        child: image,
      );
    } catch (e, stackTrace) {
      debugPrint("error: $e");
      debugPrintStack(stackTrace: stackTrace);
      return const SizedBox();
    }
  }
}
