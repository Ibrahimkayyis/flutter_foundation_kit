// import 'package:flutter/material.dart';

// class IAUserAvatarScope extends InheritedWidget {
//   final String timestamp;
//   final String token;
//   final void Function(String token) setToken;
//   final void Function() refresh;

//   const IAUserAvatarScope({
//     super.key,
//     required super.child,
//     required this.timestamp,
//     required this.setToken,
//     required this.refresh,
//     required this.token,
//   });

//   static IAUserAvatarScope of(BuildContext context) {
//     final result =
//         context.dependOnInheritedWidgetOfExactType<IAUserAvatarScope>();
//     if (result == null) throw "No IAUserAvataScope found in the tree";
//     return result;
//   }

//   static IAUserAvatarScope? maybeOf(BuildContext context) {
//     final result =
//         context.dependOnInheritedWidgetOfExactType<IAUserAvatarScope>();
//     return result;
//   }

//   @override
//   bool updateShouldNotify(covariant IAUserAvatarScope oldWidget) {
//     return timestamp != oldWidget.timestamp;
//   }
// }

// class IAAvatarProvider extends StatefulWidget {
//   final String token;
//   final Widget child;
//   const IAAvatarProvider({super.key, required this.token, required this.child});

//   @override
//   State<IAAvatarProvider> createState() => _IAAvatarProviderState();
// }

// class _IAAvatarProviderState extends State<IAAvatarProvider> {
//   String _keyCounter = DateTime.now().toIso8601String();
//   late String _token;

//   @override
//   void initState() {
//     super.initState();
//     _token = widget.token;
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       setState(() {
//         _keyCounter = DateTime.now().toIso8601String();
//       });
//     });
//   }

//   @override
//   void didUpdateWidget(covariant IAAvatarProvider oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _token = widget.token;
//     _keyCounter = DateTime.now().toIso8601String();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IAUserAvatarScope(
//       setToken: (newToken) {
//         setState(() {
//           _token = newToken;
//         });
//       },
//       refresh: () {
//         setState(() {
//           _keyCounter = DateTime.now().toString();
//         });
//       },
//       timestamp: _keyCounter,
//       token: _token,
//       child: widget.child,
//     );
//   }
// }

// // class IAUserAvatar extends StatelessWidget {
// //   final double? radius;
// //   final BoxFit? fit;
// //   final bool disableOnTap;
// //   const IAUserAvatar({
// //     super.key,
// //     this.radius,
// //     this.fit,
// //     this.disableOnTap = false,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final scope = IAUserAvatarScope.of(context);
// //     return NTICircleAvatar.userProfile(
// //       token: scope.token,
// //       key: Key("user_profile${scope.timestamp}"),
// //       fit: fit,
// //       disableOnTap: disableOnTap,
// //       radius: radius,
// //     );
// //   }
// // }
