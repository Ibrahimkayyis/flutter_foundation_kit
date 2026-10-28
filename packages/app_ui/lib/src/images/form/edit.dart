part of 'image_form.dart';

sealed class NTIImageEditorResult {}

class NTIImageEditorResultNewImage extends NTIImageEditorResult {
  final NTIFileImage image;

  NTIImageEditorResultNewImage({required this.image});
}

class NTIImageEditorResultDelete extends NTIImageEditorResult {}

class NTIImageEditor extends StatefulWidget {
  final String? title;
  final NTICropConfig? cropConfig;
  final bool cropAfterPick;
  final String? pickerTitle;
  final NTIImagePickerController? controller;
  final NTIImage? initialImage;
  final String? removeTitle;
  final String? removeDesc;
  const NTIImageEditor({
    super.key,
    required this.controller,
    this.title,
    required this.cropConfig,
    this.initialImage,
    this.pickerTitle,
    this.cropAfterPick = true,
    this.removeTitle,
    this.removeDesc,
  });

  static Future<NTIImageEditorResult?> launch(
    BuildContext context, {
    String? title,
    String? pickerTitle,
    bool cropAfterPick = true,
    String? removeTitle,
    String? removeDesc,
    NTIImage? initialImage,
    NTICropConfig? cropConfig,
    NTIImagePickerController? controller,
  }) async {
    final result = await showDialog(
      useSafeArea: false,
      context: context,
      barrierColor: Colors.transparent,
      builder:
          (context) => NTIImageEditor(
            cropConfig: cropConfig,
            controller: controller,
            title: title,
            initialImage: initialImage,
            removeDesc: removeDesc,
            removeTitle: removeTitle,
            cropAfterPick: cropAfterPick,
            pickerTitle: pickerTitle,
          ),
    );
    if (result is! NTIImageEditorResult) return null;
    return result;
  }

  @override
  State<NTIImageEditor> createState() => _NTIImageEditorState();
}

class _NTIImageEditorState extends State<NTIImageEditor> {
  late final ValueNotifier<NTIImage?> _image;

  @override
  void initState() {
    super.initState();
    _image =
        widget.controller ??
        NTIImagePickerController(initialValue: widget.initialImage);
  }

  void _pickImage() async {
    final result = await NTIImageSourceWidget.launch(
      context,
      title: widget.pickerTitle,
    );
    if (result == null) return;
    final image = await NTIImagePickerUtil.pickImage(
      config: widget.cropConfig,
      source: result,
      cropImageFirst: widget.cropAfterPick,
    );
    if (image == null) return;
    _image.value = NTIFileImage(
      filepath: image.path,
      name: path.basename(image.path),
    );
  }

  // void _removeImage() async {
  //   final router = context.router;
  //   final isRemoveConfirmed = await IAConfirmationDialog.show(context,
  //       title: widget.removeTitle ?? "Hapus Foto",
  //       confirmText: "Tidak",
  //       cancelText: "Hapus",
  //       desc: widget.removeDesc ?? "apa anda yakin akan hapus foto",
  //       reverseMode: true);
  //   if (!isRemoveConfirmed) return;
  //   _image.value = null;
  //   router.maybePop(IAImageEditorResultDelete());
  // }

  @override
  void dispose() {
    if (widget.controller == null) {
      _image.dispose();
    }
    super.dispose();
  }

  void _onPop(bool didPop, dynamic result) async {
    if (didPop) return;
    final initialImage = widget.initialImage;
    final newImage = _image.value;
    if (newImage == null || newImage is! NTIFileImage) return;
    final result =
        newImage != initialImage
            ? NTIImageEditorResultNewImage(image: newImage)
            : null;
    Navigator.of(context).pop(result);
  }

  BoxShape _getBoxShape() {
    if (widget.cropConfig == null ||
        widget.cropConfig?.cropStyle == NTICropStyle.rectanlge) {
      return BoxShape.rectangle;
    }
    return BoxShape.circle;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    return PopScope(
      onPopInvokedWithResult: _onPop,
      child: Scaffold(
        backgroundColor: color.basic10Reverse.withAlpha((.95 * 255).round()),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16).copyWith(bottom: 0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: AppIcon(AppIcons.left, color: color.basic1Reverse),
                    ),
                    Expanded(
                      child: Text(
                        widget.title ?? "GAMBAR",
                        style: context.text.lg.copyWith(
                          color: color.basic1,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: _pickImage,
                      child: AppIcon(AppIcons.edit, color: color.basic1),
                    ),
                  ],
                ),
              ),
              32.verticalSpace,
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _image,
                  builder: (context, value, child) {
                    if (value == null) return const SizedBox();
                    return PhotoView.customChild(
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: _getBoxShape(),
                          image: DecorationImage(
                            image: value.provider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              32.verticalSpace,
              // Padding(
              //   padding: const EdgeInsets.all(16).copyWith(top: 0),
              //   child: IABaseOutlineButton(
              //     onPressed: _removeImage,
              //     text: "Hapus Foto",
              //     isFillParent: true,
              //     borderColor: color.basic7,
              //     padding: ButtonSize.defaultSize.padding,
              //     disableBackgroundColor: context.colorTheme.basic1,
              //     disableBorderColor: context.colorTheme.basic5,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
