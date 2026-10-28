part of 'bottomsheet.dart';

class NTIBottomSheetActions {
  static Future<dynamic> launch(
    BuildContext context, {
    required String title,
    Widget? beforeItemWidget,
    required List<NTIBottomSheetListItem> items,
  }) async {
    return await showModalBottomSheet(
      context: context,
      shape: NTIBottomSheet.basicBorder(),
      builder: (context) {
        return NTIBottomSheetListTile(
          title: title,
          items: items,
          beforeItemWidget: beforeItemWidget,
        );
      },
    );
  }

  // static Future<T?> launchAsync<T>( BuildContext context,
  //     {required String title, required List<T> items}) {
  //   return NTIBottomSheetListTile(
  //     title: title,
  //     items: items.map(
  //       (e) {

  //       },
  //     ),
  //   );
  // }
}

class NTIBottomSheetListItem {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailling;
  final VoidCallback? onClick;
  final ShapeBorder? shape;
  final bool? dense;
  final AppIcons? leadingIcon;
  final TextStyle? titleTextStyle;
  final Color? textColor;
  final Color? iconColor;
  const NTIBottomSheetListItem({
    required this.title,
    this.subtitle,
    this.leading,
    this.onClick,
    this.leadingIcon,
    this.trailling,
    this.shape,
    this.dense,
    this.titleTextStyle,
    this.textColor,
    this.iconColor,
  });
}

class NTIBottomSheetListTile extends NTIBottomSheetScrollable {
  final EdgeInsets? contentPadding;
  final String? title;
  final TextStyle? titleStyle;
  final TextStyle? itemSubtitleStyle;
  final List<NTIBottomSheetListItem> items;
  final double headerGap;
  final double itemGap;
  final Widget? beforeItemWidget;

  NTIBottomSheetListTile({
    super.key,
    super.headerColor,
    super.headerSize,
    this.contentPadding,
    this.items = const [],
    this.title,
    this.itemSubtitleStyle,
    this.titleStyle,
    this.headerGap = 12,
    this.itemGap = 0,
    this.beforeItemWidget,
    super.padding,
  }) : super(
         content:
             (context) => Padding(
               padding: contentPadding ?? const EdgeInsets.only(top: 24),
               child: Column(
                 children: [
                   if (title != null)
                     Text(
                       title,
                       style:
                           titleStyle ??
                           context.text.base.copyWith(
                             fontWeight: FontWeight.bold,
                             color: context.colorTheme.basic10Reverse,
                           ),
                     ),
                   if (title != null) SizedBox(height: headerGap),
                   if (beforeItemWidget != null) beforeItemWidget,
                   ...items.map(
                     (item) => Padding(
                       padding:
                           !(itemGap / 2).isNaN
                               ? EdgeInsets.symmetric(vertical: itemGap / 2)
                               : EdgeInsets.zero,
                       child: ListTile(
                         trailing: item.trailling,
                         leading: () {
                           final leadingWidget = item.leading;
                           if (leadingWidget != null) return leadingWidget;
                           final icon = item.leadingIcon;
                           if (icon == null) return null;
                           return AppIcon(
                             icon,
                             height: 24,
                             color: item.iconColor,
                           );
                         }(),
                         title: Text(
                           item.title,
                           style:
                               item.titleTextStyle ??
                               context.text.sm.copyWith(color: item.textColor),
                         ),
                         subtitle:
                             item.subtitle != null
                                 ? Text(
                                   item.subtitle!,
                                   style: itemSubtitleStyle,
                                 )
                                 : null,
                         onTap: item.onClick,
                         shape: item.shape,
                         dense: item.dense,
                       ),
                     ),
                   ),
                 ],
               ),
             ),
       );
}
