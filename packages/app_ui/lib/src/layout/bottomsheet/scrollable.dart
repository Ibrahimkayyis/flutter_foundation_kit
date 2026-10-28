part of 'bottomsheet.dart';

class NTIBottomSheetScrollable extends NTIBottomSheet {
  final EdgeInsets? padding;
  final WidgetBuilder content;
  NTIBottomSheetScrollable({
    super.key,
    super.headerColor,
    super.headerSize,
    this.padding,
    required this.content,
  }) : super(
         builder: (context, header) {
           return SingleChildScrollView(
             child: Padding(
               padding: padding ?? const EdgeInsets.all(24),
               child: Column(children: [header, content(context)]),
             ),
           );
         },
       );
}
