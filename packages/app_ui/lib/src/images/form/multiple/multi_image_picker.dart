part of '../image_form.dart';

class NTIMultiImageField extends StatefulWidget {
  final List<NTIImage> initialImages;
  final NTIMultiImageFieldController? controller;
  final String? label;
  final double height;
  final bool readOnly;
  final String? desc;
  final String? pickerTitle;
  final int? max;
  final void Function(List<NTIImage> result)? onSaved;
  final String? Function(List<NTIImage> result)? validator;
  const NTIMultiImageField({
    super.key,
    this.height = 64,
    this.desc,
    this.onSaved,
    this.max,
    this.initialImages = const [],
    this.label,
    this.readOnly = false,
    this.controller,
    this.validator,
    this.pickerTitle,
  }) : assert(max == null || max > 0, "Max only accept null or more than 0");

  @override
  State<NTIMultiImageField> createState() => _NTIMultiImageFieldState();
}

class NTIMultiImageFieldController extends ValueNotifier<List<NTIImage>> {
  NTIMultiImageFieldController({List<NTIImage> initialValue = const []})
    : super(initialValue);
}

class _NTIMultiImageFieldState extends State<NTIMultiImageField> {
  late final NTIMultiImageFieldController _controller;
  List<NTIImage> _images = [];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? NTIMultiImageFieldController();
    _controller.addListener(_imageChangeListener);
    _controller.value = widget.initialImages;
  }

  @override
  void dispose() {
    _controller.removeListener(_imageChangeListener);
    super.dispose();
  }

  void _imageChangeListener() {
    setState(() {
      _images = _controller.value;
    });
  }

  void _pickImage() async {
    final source = await NTIImageSourceWidget.launch(
      context,
      title: widget.pickerTitle,
    );
    if (source == null) return;
    final images = await NTIImagePickerUtil.pickImages(
      source: source,
      max: widget.max == null ? null : widget.max! - _images.length,
    );
    if (images.isEmpty) return;
    _controller.value = [
      ...images.map(
        (e) => NTIFileImage(filepath: e.path, name: path.basename(e.path)),
      ),
      ..._controller.value,
    ];
  }

  void _openImage(BuildContext context, {int startingIndex = 0}) {
    NTIImagesCarousel.showAsDialog(
      context,
      images: _controller.value.map((e) => e.provider).toList(),
      initialIndex: startingIndex,
    );
  }

  void _editImage(BuildContext context, {int startingIndex = 0}) async {
    final images = await NTIImagePickerWithPreview.pick(
      context,
      max: widget.max,
      initialImage: _controller.value,
      initialIndex: startingIndex,
    );
    if (images.isEmpty) return;
    _controller.value = images;
  }

  bool get _canAddMore {
    final max = widget.max;
    if (max == null) return true;
    return _controller.value.length < max;
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    final text = context.text;

    return FormField(
      onSaved: (_) => widget.onSaved?.call(_images),
      validator: (_) {
        return widget.validator?.call(_images);
      },
      builder:
          (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(widget.label ?? "", style: text.sm),
                ),
              Container(
                alignment: Alignment.centerLeft,
                height: widget.height,
                child:
                    _images.isEmpty
                        ? _MultipleImageAddButton(onPickImage: _pickImage)
                        : Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 9),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children:
                                        _images
                                            .mapIndexed(
                                              (i, e) => Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 12,
                                                ),
                                                child: GestureDetector(
                                                  onTap:
                                                      () =>
                                                          widget.readOnly
                                                              ? _openImage(
                                                                context,
                                                              )
                                                              : _editImage(
                                                                context,
                                                                startingIndex:
                                                                    i,
                                                              ),
                                                  child: Container(
                                                    width: widget.height,
                                                    height: widget.height,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        if (!widget.readOnly)
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withAlpha(128),
                                                            spreadRadius: .1,
                                                            blurRadius: 6,
                                                            offset: const Offset(
                                                              0,
                                                              0,
                                                            ), // changes position of shadow
                                                          ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      image: DecorationImage(
                                                        image: e.provider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ),
                              ),
                            ),
                            if (!widget.readOnly && _canAddMore)
                              _MultipleImageAddButton(onPickImage: _pickImage),
                          ],
                        ),
              ),
              if (field.hasError)
                Text(
                  field.errorText!,
                  style: text.sm.applyColor(color.systemDanger),
                ),
            ],
          ),
    );
  }
}

class _MultipleImageAddButton extends StatelessWidget {
  final VoidCallback onPickImage;
  final String? addText;
  const _MultipleImageAddButton({required this.onPickImage, this.addText});

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    final text = context.text;
    return InkWell(
      onTap: onPickImage,
      child: LayoutBuilder(
        builder: (_, constraint) {
          return Container(
            width: constraint.maxHeight,
            decoration: BoxDecoration(
              color: color.basic3,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcon(
                  AppIcons.plus,
                  height: min(24, constraint.maxHeight * 1 / 3),
                ),
                4.h.verticalSpace,
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    addText ?? "Unggah",
                    style: text.sm.copyWith(
                      color: color.basic10,
                      fontSize: min(16, constraint.maxHeight * 2 / 3),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
