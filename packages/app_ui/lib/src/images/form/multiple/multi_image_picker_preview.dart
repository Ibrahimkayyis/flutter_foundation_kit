part of '../image_form.dart';

class NTIImagePickerWithPreview extends StatefulWidget {
  final List<NTIImage> initialImage;
  final int initialIndex;
  final int? max;
  const NTIImagePickerWithPreview._(
    this.initialImage, {
    this.initialIndex = 0,
    this.max,
  });

  static Future<List<NTIImage>> pick(
    BuildContext context, {
    List<NTIImage>? initialImage,
    int initialIndex = 0,
    int? max,
  }) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => NTIImagePickerWithPreview._(
              initialImage ?? [],
              max: max,
              initialIndex: initialIndex,
            ),
      ),
    );
    if (result is List<NTIImage>) return result;
    return [];
  }

  @override
  State<NTIImagePickerWithPreview> createState() =>
      _NTIImagePickerWithPreviewState();
}

class _NTIImagePickerWithPreviewState extends State<NTIImagePickerWithPreview> {
  final List<NTIImage> _images = [];
  int? _selectedIndex;
  final ValueNotifier<bool> _showAction = ValueNotifier(true);
  final NTICarouselController _carouselController = NTICarouselController();
  final _previewController = ScrollController();
  static const _actionDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    if (widget.initialImage.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        pickImage();
      });
    } else {
      _images.addAll(widget.initialImage);
      _selectedIndex = widget.initialIndex;
    }
  }

  void pickImage() async {
    final source = await NTIImageSourceWidget.launch(context);
    if (source == null) return;
    final images = await NTIImagePickerUtil.pickImages(
      source: source,
      max: widget.max == null ? null : widget.max! - _images.length,
    );
    if (images.isEmpty) return;
    _selectedIndex = images.isEmpty ? 0 : images.length + 1;
    _images.addAll(
      images.map(
        (e) => NTIFileImage(filepath: e.path, name: path.basename(e.path)),
      ),
    );
    setState(() {});
    if (_selectedIndex == null) return;
    triggerCaraouselChange(_selectedIndex!);
  }

  void triggerCaraouselChange(int index) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _carouselController.jumpToPage(index);
    });
  }

  void _onRemove(int index) {
    setState(() {
      _images.removeAt(index);
      _selectedIndex = 0;
      triggerCaraouselChange(0);
    });
  }

  void _toggleAction() {
    setState(() {
      _showAction.value = !_showAction.value;
    });
  }

  bool get _canAddMoreImage {
    final max = widget.max;
    if (max == null) return true;
    return _images.length < max;
  }

  @override
  void dispose() {
    _showAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          NTIImagesCarousel.full(
            context,
            controller: _carouselController,
            onPageChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            images:
                _images
                    .map((e) => NTIImageCarouselData(provider: e.provider))
                    .toList(),
            initialIndex: widget.initialIndex,
          ),
          SizedBox.expand(child: GestureDetector(onTap: _toggleAction)),
          ValueListenableBuilder(
            valueListenable: _showAction,
            builder: (_, showAction, __) {
              return AnimatedOpacity(
                opacity: showAction ? 1 : 0,
                duration: _actionDuration,
                child: SafeArea(
                  child: _CarouselFullScreenHeader(
                    _selectedIndex,
                    _images.length,
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: _showAction,
            builder: (_, showAction, __) {
              return AnimatedOpacity(
                duration: _actionDuration,
                opacity: showAction ? 1 : 0,
                child: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(16).copyWith(bottom: 32.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_images.length > 1)
                          SingleChildScrollView(
                            controller: _previewController,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  _images
                                      .mapIndexed(
                                        (i, e) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                          ),
                                          child: _ImagePreviewItem(
                                            isSelected: i == _selectedIndex,
                                            item: e,
                                            onRemove: () => _onRemove(i),
                                            onSelected: () {
                                              setState(() {
                                                _selectedIndex = i;
                                              });
                                              triggerCaraouselChange(i);
                                            },
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        32.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_canAddMoreImage)
                              AppDefaultButton(
                                text: "Add More",
                                buttonType: ButtonType.secondary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 28,
                                ),
                                onPressed: pickImage,
                                // foregroundColor: Colors.white,
                              ),
                            const Expanded(child: SizedBox()),
                            FloatingActionButton(
                              onPressed: () {
                                Navigator.of(context).maybePop(_images);
                              },
                              backgroundColor: context.colorTheme.brandAccent10,
                              child: const Icon(Icons.send),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ImagePreviewItem extends StatelessWidget {
  final NTIImage item;
  final bool isSelected;
  final VoidCallback onRemove;
  final VoidCallback onSelected;
  const _ImagePreviewItem({
    required this.item,
    required this.isSelected,
    required this.onRemove,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        height: 84,
        width: 84,
        decoration: BoxDecoration(
          border:
              isSelected
                  ? Border.all(
                    color: Colors.white,
                    width: 2,
                    style: BorderStyle.solid,
                  )
                  : null,
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(fit: BoxFit.cover, image: item.provider),
        ),
        child:
            !isSelected
                ? null
                : GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withAlpha((.5 * 255).round()),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
      ),
    );
  }
}

class _CarouselFullScreenHeader extends StatelessWidget {
  final int? index;
  final int total;
  const _CarouselFullScreenHeader(this.index, this.total);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            child: const AppIcon(
              AppIcons.close,
              color: Colors.white,
              height: 28,
            ),
          ),
          if (index != null)
            Text(
              "${index! + 1}/$total",
              style: context.text.lg.copyWith(
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
        ],
      ),
    );
  }
}

extension _IterableExt<T> on Iterable<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T element) f) {
    var index = 0;
    return map((e) => f(index++, e));
  }
}
