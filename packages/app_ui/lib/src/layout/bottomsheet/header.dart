part of 'bottomsheet.dart';

class _BottomSheetHeader extends StatelessWidget {
  final Size? size;
  final Color? color;
  const _BottomSheetHeader({this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size?.width ?? screenSize.width * .2,
          height: size?.height ?? 6,
          decoration: BoxDecoration(
            color: color ?? context.colorTheme.basic5Reverse,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
