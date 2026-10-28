part of 'loading.dart';

class NTILoadingContainer extends StatefulWidget {
  final Color? circularColor;
  final double? radius;
  final bool isInitialyLoading;
  final Widget child;
  final String? text;
  final TextStyle? textStyle;
  final Duration? loadingDuration;
  final int numberOfDots;
  final double textToCircularSpacing;
  final Stream<bool> isLoadingStream;
  const NTILoadingContainer({
    super.key,
    this.circularColor,
    this.radius,
    this.text,

    this.textStyle,
    this.textToCircularSpacing = 12,
    this.loadingDuration = const Duration(milliseconds: 500),
    this.numberOfDots = 5,
    this.isInitialyLoading = false,
    required this.isLoadingStream,
    required this.child,
  });

  @override
  State<NTILoadingContainer> createState() => _NTILoadingContainerState();
}

class _NTILoadingContainerState extends State<NTILoadingContainer> {
  OverlayEntry? overlayEntry;
  StreamSubscription<bool>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      if (!widget.isInitialyLoading) return;
      _showOverlay();
    });
  }

  @override
  void didUpdateWidget(NTILoadingContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoadingStream != widget.isLoadingStream) {
      if (_subscription != null) {
        _unsubscribe();
      }
      _subscribe();
    }
  }

  Widget _contentBuilder(BuildContext context) {
    return NTILoadingOverlay(
      text: widget.text,
      circularColor: widget.circularColor,
      loadingDuration: widget.loadingDuration,
      numberOfDots: widget.numberOfDots,
      radius: widget.radius,
      textStyle:
          widget.textStyle ??
          context.text.lg.copyWith(color: context.colorTheme.basic1Reverse),
      textToCircularSpacing: widget.textToCircularSpacing,
    );
  }

  void _showOverlay() {
    if (overlayEntry != null) return;
    overlayEntry = OverlayEntry(builder: (context) => _contentBuilder(context));
    Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry!);
  }

  // Remove the OverlayEntry.
  void _removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
  }

  void _subscribe() {
    _subscription = widget.isLoadingStream.listen((data) {
      if (data) _showOverlay();
      if (!data) _removeHighlightOverlay();
    });
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    // Make sure to remove OverlayEntry when the widget is disposed.
    _removeHighlightOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
