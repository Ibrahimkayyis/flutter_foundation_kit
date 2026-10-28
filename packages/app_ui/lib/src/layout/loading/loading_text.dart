part of 'loading.dart';

class NTILoadingText extends StatefulWidget {
  final String data;
  final TextStyle? style;
  final Duration loadingDuration;
  final int numberOfDots;
  const NTILoadingText(
    this.data, {
    super.key,
    this.style,
    this.loadingDuration = const Duration(milliseconds: 500),
    this.numberOfDots = 5,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NTILoadingTextState createState() => _NTILoadingTextState();
}

class _NTILoadingTextState extends State<NTILoadingText> {
  Timer? _debounce;

  var text = "";
  var currentLoop = 0;

  @override
  void initState() {
    text = widget.data;
    _debounce = Timer.periodic(widget.loadingDuration, (_) {
      if (currentLoop < widget.numberOfDots) {
        text += " .";
        currentLoop++;
      } else {
        currentLoop = 0;
        text = widget.data;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(text, style: widget.style);
  }
}
