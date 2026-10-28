import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/src/icon/nti_icon/icon.dart';
import 'package:app_ui/src/style/styles.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

part 'image_carousel_with_dots.dart';
part 'image_fullscreen.dart';

class NTIImageCarouselData {
  final ImageProvider provider;
  final BoxFit? boxFit;

  NTIImageCarouselData({required this.provider, this.boxFit});
}

typedef NTICarouselOption = CarouselOptions;
typedef NTICarousel = CarouselSlider;
typedef NTICarouselController = CarouselSliderControllerImpl;

class NTIImagesCarousel extends StatefulWidget {
  final List<NTIImageCarouselData> imageList;
  final List<NTIImageCarouselData>? fullScreenImages;
  final NTICarouselController? carouselController;
  final NTICarouselOption? carouselOption;
  final BoxFit? boxFit;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets? margin;
  final bool fullscreenOnTap;
  final bool _isFullScreen;

  const NTIImagesCarousel({
    super.key,
    required this.imageList,
    this.carouselController,
    this.carouselOption,
    this.boxFit,
    this.fullScreenImages,
    this.border,
    this.margin,
    this.borderRadius,
    this.fullscreenOnTap = true,
  }) : _isFullScreen = false;

  const NTIImagesCarousel._(
    this._isFullScreen, {
    required this.imageList,
    // ignore: unused_element, unused_element_parameter
    this.fullScreenImages = const [],
    // ignore: unused_element
    this.carouselController,
    this.carouselOption,
    this.boxFit,
    // ignore: unused_element, unused_element_parameter
    this.border,
    this.margin,
    this.fullscreenOnTap = false,
    // ignore: unused_element, unused_element_parameter
    this.borderRadius,
  });

  factory NTIImagesCarousel.full(
    BuildContext context, {
    required List<NTIImageCarouselData> images,
    int initialIndex = 0,
    NTICarouselController? controller,
    dynamic Function(int index)? onPageChange,
  }) => NTIImagesCarousel._(
    true,
    imageList:
        images
            .map(
              (e) => NTIImageCarouselData(
                provider: e.provider,
                boxFit: BoxFit.contain,
              ),
            )
            .toList(),
    fullscreenOnTap: false,
    boxFit: BoxFit.contain,
    margin: EdgeInsets.zero,
    carouselController: controller,
    carouselOption: NTICarouselOption(
      initialPage: initialIndex,
      viewportFraction: 1,
      onPageChanged: (index, reason) => onPageChange?.call(index),
      enlargeCenterPage: false,
      height: MediaQuery.of(context).size.height,
    ),
  );

  static showAsDialog(
    BuildContext context, {
    required List<ImageProvider> images,
    int initialIndex = 0,
  }) {
    showDialog(
      context: context,
      barrierLabel: '',
      useSafeArea: false,
      useRootNavigator: false,
      barrierColor: Colors.transparent,
      builder:
          (context) =>
              _CarousellFullscreen(images: images, initialIndex: initialIndex),
    );
  }

  @override
  State<NTIImagesCarousel> createState() => _NTIImagesCarouselState();
}

class _NTIImagesCarouselState<T extends NTIImagesCarousel> extends State<T> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showCarouselDialog(int index) {
    NTIImagesCarousel.showAsDialog(
      context,
      initialIndex: index,
      images:
          widget.fullScreenImages?.map((e) => e.provider).toList() ??
          widget.imageList.map((e) => e.provider).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: widget.carouselOption ?? CarouselOptions(),
      carouselController: widget.carouselController,
      items:
          widget.imageList.mapIndexed((i, item) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap:
                      () =>
                          (!widget._isFullScreen && widget.fullscreenOnTap)
                              ? _showCarouselDialog(i)
                              : null,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        widget.margin ??
                        const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration:
                        widget._isFullScreen
                            ? null
                            : BoxDecoration(
                              border: widget.border,
                              borderRadius: widget.borderRadius,
                              image: DecorationImage(
                                image: item.provider,
                                fit:
                                    item.boxFit ??
                                    widget.boxFit ??
                                    BoxFit.cover,
                              ),
                            ),
                    child:
                        widget._isFullScreen
                            ? PhotoView(
                              imageProvider: item.provider,
                              backgroundDecoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                            )
                            : null,
                  ),
                );
              },
            );
          }).toList(),
    );
  }
}

extension _ListExtension<E> on List<E> {
  List<T> mapIndexed<T>(T Function(int index, E item) mapper) {
    return List.generate(length, (index) => mapper(index, this[index]));
  }
}


typedef AppImageCarouselData = NTIImageCarouselData;
typedef AppImagesCarousel = NTIImagesCarousel;
typedef AppCarouselOption = NTICarouselOption;
typedef AppCarousel = NTICarousel;
typedef AppCarouselController = NTICarouselController;
