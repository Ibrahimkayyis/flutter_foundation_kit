part of 'bottomsheet.dart';

class NTIBottomSheetExpanded extends NTIBottomSheet {
  final EdgeInsets? padding;
  final Widget content;
  NTIBottomSheetExpanded({
    super.key,
    super.headerColor,
    super.headerSize,
    this.padding,
    required this.content,
  }) : super(
         builder: (context, header) {
           return Padding(
             padding: padding ?? const EdgeInsets.all(12),
             child: Column(children: [header, Expanded(child: content)]),
           );
         },
       );
}
