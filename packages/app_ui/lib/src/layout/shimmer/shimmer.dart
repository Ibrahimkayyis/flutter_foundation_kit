import 'package:flutter/material.dart';
import 'package:app_ui/src/style/styles.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class NTIRectanleShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Duration duration;

  const NTIRectanleShimmer({
    super.key,
    required this.width,
    required this.height,
    this.radius = 12,
    this.duration = const Duration(seconds: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: duration,
      color: context.colorTheme.basic1Reverse,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.colorTheme.basic6Reverse,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
