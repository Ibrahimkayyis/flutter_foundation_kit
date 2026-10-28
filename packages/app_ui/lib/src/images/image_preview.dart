import 'package:flutter/material.dart';
import 'package:app_ui/src/icon/index.dart';
import 'package:photo_view/photo_view.dart';

class NTIImagePreview extends StatefulWidget {
  final ImageProvider image;
  final double? opacity;
  final List<Widget> actions;
  const NTIImagePreview._({
    required this.image,
    this.opacity,
    this.actions = const [],
  });

  static Future<dynamic> asFullScreenDialog(
    BuildContext context,
    ImageProvider image, {
    double? opacity,
    List<Widget> actions = const [],
  }) {
    return showDialog(
      useSafeArea: false,
      useRootNavigator: false,
      context: context,
      builder:
          (_) => NTIImagePreview._(
            image: image,
            actions: actions,
            opacity: opacity,
          ),
      barrierColor: Colors.transparent,
    );
  }

  @override
  State<NTIImagePreview> createState() => _NTIImagePreviewState();
}

class _NTIImagePreviewState extends State<NTIImagePreview> {
  final ValueNotifier<_DragState> _state = ValueNotifier(_DragState());

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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: PhotoView(
                    imageProvider: widget.image,
                    backgroundDecoration: BoxDecoration(
                      color: Colors.black.withAlpha((.5 * 255).round()),
                    ),
                  ),
                ),
                SizedBox.expand(child: GestureDetector(onTap: _toggleAction)),
                ValueListenableBuilder(
                  valueListenable: _state,
                  builder: (_, state, __) {
                    return Row(
                      children: [
                        AnimatedOpacity(
                          opacity: state.showAction ? 1 : 0,
                          duration: _actionDuration,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: SafeArea(
                              child: InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: const AppIcon(
                                  AppIcons.close,
                                  color: Colors.white,
                                  height: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (widget.actions.isNotEmpty)
                          const Expanded(child: SizedBox()),
                        if (widget.actions.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: SafeArea(
                              child: Row(children: widget.actions),
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

class _DragState {
  final double swipeProgress;
  final bool actionActive;

  _DragState({this.swipeProgress = 0, this.actionActive = true});

  double get bgOpacity => 1 - (swipeProgress / 3);

  bool get showAction => actionActive && swipeProgress == 0;

  _DragState copyWith({double? swipeProgress, bool? actionActive}) =>
      _DragState(
        swipeProgress: swipeProgress ?? this.swipeProgress,
        actionActive: actionActive ?? this.actionActive,
      );
}
