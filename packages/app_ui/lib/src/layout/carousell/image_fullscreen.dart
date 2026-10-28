part of 'image_carousel.dart';

class _CarouselFullScreenStateData {
  final double swipeProgress;
  final bool actionActive;

  _CarouselFullScreenStateData({
    this.swipeProgress = 0,
    this.actionActive = true,
  });

  double get bgOpacity => 1 - (swipeProgress / 3);

  bool get showAction => actionActive && swipeProgress == 0;

  _CarouselFullScreenStateData copyWith({
    double? swipeProgress,
    bool? actionActive,
  }) => _CarouselFullScreenStateData(
    swipeProgress: swipeProgress ?? this.swipeProgress,
    actionActive: actionActive ?? this.actionActive,
  );
}

class _CarousellFullscreen extends StatefulWidget {
  final List<ImageProvider> images;
  final int initialIndex;
  const _CarousellFullscreen({required this.images, this.initialIndex = 0});

  @override
  State<_CarousellFullscreen> createState() => _CarousellFullscreenState();
}

class _CarousellFullscreenState extends State<_CarousellFullscreen> {
  final ValueNotifier<_CarouselFullScreenStateData> _state = ValueNotifier(
    _CarouselFullScreenStateData(),
  );

  late final ValueNotifier<int> _index;

  static const _actionDuration = Duration(milliseconds: 200);

  void _updateProgress(double progress) {
    _state.value = _state.value.copyWith(swipeProgress: progress);
  }

  void _toggleAction() {
    _state.value = _state.value.copyWith(
      actionActive: !_state.value.actionActive,
    );
  }

  @override
  void initState() {
    super.initState();
    _index = ValueNotifier(widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: _state,
          builder: (_, state, __) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withAlpha((state.bgOpacity * 255).round()),
            );
          },
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Dismissible(
            direction: DismissDirection.vertical,
            onUpdate: (event) {
              _updateProgress(event.progress);
            },
            onDismissed: (_) {
              Navigator.of(context).pop();
            },
            key: Key(DateTime.now().toString()),
            child: Stack(
              children: [
                NTIImagesCarousel.full(
                  context,
                  initialIndex: widget.initialIndex,
                  onPageChange: (index) {
                    _index.value = index;
                  },
                  images:
                      widget.images
                          .map(
                            (e) => NTIImageCarouselData(
                              provider: e,
                              boxFit: BoxFit.contain,
                            ),
                          )
                          .toList(),
                ),
                SizedBox.expand(child: GestureDetector(onTap: _toggleAction)),
                ValueListenableBuilder(
                  valueListenable: _state,
                  builder: (_, state, __) {
                    return Column(
                      children: [
                        AnimatedOpacity(
                          opacity: state.showAction ? 1 : 0,
                          duration: _actionDuration,
                          child: SafeArea(
                            child: _CarouselFullScreenHeader(
                              _index,
                              widget.images.length,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CarouselFullScreenHeader extends StatelessWidget {
  final ValueNotifier<int> indexNotifier;
  final int total;
  const _CarouselFullScreenHeader(this.indexNotifier, this.total);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const AppIcon(
              AppIcons.close,
              color: Colors.white,
              height: 28,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: indexNotifier,
            builder: (_, index, __) {
              return Text(
                "${index + 1}/$total",
                style: context.text.lg.copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
