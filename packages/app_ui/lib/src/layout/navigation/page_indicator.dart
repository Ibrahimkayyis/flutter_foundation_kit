import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NTIPageIndicator extends StatefulWidget {
  final int count;
  final PageController controller;
  final void Function(int)? onDotClicked;
  final Color? dotColor;
  final Color? activeColor;
  final double? dotWidth;
  final double? dotHeight;
  const NTIPageIndicator({
    super.key,
    required this.count,
    required this.controller,
    this.onDotClicked,
    this.dotColor,
    this.activeColor,
    this.dotWidth,
    this.dotHeight,
  });

  @override
  NTIPageIndicatorState createState() => NTIPageIndicatorState();
}

class NTIPageIndicatorState extends State<NTIPageIndicator> {
  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      onDotClicked: widget.onDotClicked,
      controller: widget.controller,
      count: widget.count,
      effect: ExpandingDotsEffect(
        dotHeight: widget.dotHeight ?? 16,
        dotWidth: widget.dotWidth ?? 16,
        dotColor: widget.dotColor ?? const Color(0xffF0F0F0),
        activeDotColor: widget.activeColor ?? const Color(0xffFFB803),
      ),
    );
  }
}
