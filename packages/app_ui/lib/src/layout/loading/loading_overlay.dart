part of 'loading.dart';

class NTILoadingOverlay extends StatelessWidget {
  final Color? circularColor;
  final double? radius;
  final bool isInitialyLoading;
  final String? text;
  final TextStyle? textStyle;
  final Duration? loadingDuration;
  final int numberOfDots;
  final double textToCircularSpacing;
  const NTILoadingOverlay({
    super.key,
    this.circularColor,
    this.radius,
    this.text,
    this.textStyle,
    this.textToCircularSpacing = 12,
    this.loadingDuration = const Duration(milliseconds: 500),
    this.numberOfDots = 5,
    this.isInitialyLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withAlpha((.5 * 255).round()),
      alignment: Alignment.center,
      child:
          text != null
              ? NTICircularProgressText(
                text: text!,
                circularColor: circularColor,
                loadingDuration: loadingDuration,
                numberOfDots: numberOfDots,
                radius: radius,
                textStyle: textStyle,
                textToCircularSpacing: textToCircularSpacing,
              )
              : Card(
                color: context.colorTheme.basic1Reverse,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: NTICircularLoading(
                    color: circularColor ?? context.colorTheme.primary12Reverse,
                    radius: radius ?? 16,
                  ),
                ),
              ),
    );
  }
}
