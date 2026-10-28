part of 'image_form.dart';

// class _ImageAdded extends StatelessWidget {
//   final BoxDecoration decoration;
//   const _ImageAdded({required this.decoration});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: decoration,
//       child: const Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.change_circle,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }
// }

class _AddImage extends StatelessWidget {
  const _AddImage();

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppIcon(AppIcons.plus));
  }
}
