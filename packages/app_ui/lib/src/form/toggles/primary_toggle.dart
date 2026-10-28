part of 'toggle.dart';

class NTIPrimaryToggle extends AppToggle {
  NTIPrimaryToggle({
    super.key,
    required super.onChanged,
    super.defaultValue = false,
    super.width = 52,
    super.height = 24,
    super.enableText,
    super.disableText,
    super.borderRadius = 20.0,
  }) : super(
         trackDecorationBuilder: (ctx, isToggle, circleAnimation) {
           return BoxDecoration(
             borderRadius: BorderRadius.circular(borderRadius),
             border:
                 isToggle
                     ? null
                     : Border.all(color: ctx.colorTheme.basic6Reverse),
             color:
                 circleAnimation.value == Alignment.centerLeft
                     ? ctx.colorTheme.basic5Reverse
                     : ctx.colorTheme.primary12Reverse,
           );
         },
         dotDecorationBuilder: (ctx, isToggle) {
           return const BoxDecoration(
             shape: BoxShape.circle,
             color: Colors.white,
             boxShadow: [
               BoxShadow(
                 color: Color.fromRGBO(0, 0, 0, 0.25),
                 spreadRadius: 1,
                 blurRadius: 4,
                 blurStyle: BlurStyle.normal,
                 offset: Offset(0, 0),
               ),
             ],
           );
         },
       );
}
