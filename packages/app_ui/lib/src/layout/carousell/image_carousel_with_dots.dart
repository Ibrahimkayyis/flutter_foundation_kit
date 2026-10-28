part of 'image_carousel.dart';

class NTIImageCarouselWithDots extends StatefulWidget {
  final List<NTIImageCarouselData> imageList;
  final NTICarouselController? carouselController;
  final NTICarouselOption? carouselOption;
  final BoxFit? boxFit;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets? margin;
  final bool fullscreenOnTap;
  final EdgeInsets? dotsPadding;
  final Color? dotColor;
  final Color? activeColor;

  const NTIImageCarouselWithDots({
    super.key,
    required this.imageList,
    this.carouselController,
    this.carouselOption,
    this.boxFit,
    this.border,
    this.borderRadius,
    this.margin,
    this.dotsPadding,
    this.fullscreenOnTap = true,
    this.dotColor,
    this.activeColor,
  });

  @override
  State<NTIImageCarouselWithDots> createState() =>
      __NTIImageCarouselWithDotsState();
}

class __NTIImageCarouselWithDotsState extends State<NTIImageCarouselWithDots> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);
  late final NTICarouselController _controller;

  @override
  void initState() {
    super.initState();
    _currentIndex.value = widget.carouselOption?.initialPage ?? 0;
    _controller = widget.carouselController ?? NTICarouselController();
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carosuelOption = widget.carouselOption ?? CarouselOptions();
    return Column(
      children: [
        NTIImagesCarousel(
          imageList: widget.imageList,
          border: widget.border,
          borderRadius: widget.borderRadius,
          boxFit: widget.boxFit,
          carouselController: _controller,
          fullscreenOnTap: widget.fullscreenOnTap,
          key: widget.key,
          margin: widget.margin,
          carouselOption: carosuelOption.copyWith(
            onPageChanged: (index, reason) {
              _currentIndex.value = index;
            },
          ),
        ),
        Padding(
          padding: widget.dotsPadding ?? const EdgeInsets.only(top: 22),
          child: ValueListenableBuilder(
            valueListenable: _currentIndex,
            builder:
                (context, value, child) => AnimatedSmoothIndicator(
                  count: widget.imageList.length,
                  activeIndex: value,
                  duration: Duration(
                    milliseconds:
                        (carosuelOption
                                .autoPlayAnimationDuration
                                .inMilliseconds *
                            3 ~/
                            8),
                  ),
                  effect: ExpandingDotsEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    dotColor:
                        widget.dotColor ?? context.colorTheme.basic4Reverse,
                    activeDotColor:
                        widget.activeColor ??
                        context.colorTheme.brandTeal10Reverse,
                  ),
                  onDotClicked: (index) => _controller.animateToPage(index),
                ),
          ),
        ),
      ],
    );
  }
}
