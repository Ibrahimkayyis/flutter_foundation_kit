part of 'dropdown.dart';

// class AppDropdownContent<T> extends StatelessWidget {
//   final String hintText;
//   final AppDropdownOption<T>? selected;
//   final Widget Function(T data)? selectedBuilder;
//   final TextStyle? hintStyle;
//   const AppDropdownContent({
//     super.key,
//     this.selected,
//     this.selectedBuilder,
//     required this.hintText,
//     this.hintStyle,
//   });

//   Widget get child {
//     final selected = this.selected;
//     if (selected == null) {
//       return Text(
//         hintText,
//         style: hintStyle,
//       );
//     }
//     final selectedBuilder = this.selectedBuilder;
//     if (selectedBuilder == null) return selected.child;
//     return selectedBuilder(selected.value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(child: child),
//         Icon(
//           Icons.keyboard_arrow_down_rounded,
//           color: context.colorTheme.basic12,
//         ),
//       ],
//     );
//   }
// }
