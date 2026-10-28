part of 'loading.dart';

class NTICircularLoading extends StatelessWidget {
  final Color? color;
  final double? radius;
  const NTICircularLoading({super.key, this.color, this.radius});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: radius ?? 20,
      color: color ?? context.colorTheme.primary12Reverse,
    );
  }
}
