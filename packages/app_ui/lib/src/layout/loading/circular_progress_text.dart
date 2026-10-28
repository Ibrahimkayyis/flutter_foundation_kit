part of 'loading.dart';

class NTICircularProgressText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration? loadingDuration;
  final int numberOfDots;
  final Color? circularColor;
  final double? radius;
  final double textToCircularSpacing;
  const NTICircularProgressText({
    super.key,
    required this.text,
    this.textStyle,
    this.loadingDuration,
    this.numberOfDots = 3,
    this.circularColor,
    this.radius,
    this.textToCircularSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NTICircularLoading(color: circularColor, radius: radius),
        SizedBox(height: textToCircularSpacing),
        NTILoadingText(
          text,
          loadingDuration: loadingDuration ?? const Duration(seconds: 500),
          numberOfDots: numberOfDots,
          style: textStyle,
        ),
      ],
    );
  }
}
