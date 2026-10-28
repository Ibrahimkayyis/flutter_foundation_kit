part of 'toggle.dart';

class NTISecondaryToggle extends AppToggle {
  NTISecondaryToggle({
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
                     ? Border.all(color: ctx.colorTheme.primary10Reverse)
                     : Border.all(color: ctx.colorTheme.basic6Reverse),
             color:
                 circleAnimation.value == Alignment.centerLeft
                     ? ctx.colorTheme.basic5Reverse
                     : ctx.colorTheme.primary5Reverse,
           );
         },
         dotDecorationBuilder: (ctx, isToggle) {
           return BoxDecoration(
             shape: BoxShape.circle,
             color: Colors.white,
             border:
                 isToggle
                     ? Border.all(color: ctx.colorTheme.primary6Reverse)
                     : null,
           );
         },
       );
}
