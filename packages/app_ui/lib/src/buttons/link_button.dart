part of 'button.dart';

class AppLinkButton extends AppButton {
  const AppLinkButton({
    super.key,
    required super.text,
    super.borderRadius = 8,
    required super.onPressed,
    super.buttonSize,
    super.buttonState,
    super.buttonType,
    super.isFillParent,
    super.leftIcon,
    super.padding,
    super.rightIcon,
    super.buttonToIconSpace,
    super.autoBalanceIcon,
    super.textStyle,
  });

  TextStyle _overridedTextStyle(BuildContext context) {
    final currentTextStyle = textStyle;

    final decoration =
        buttonType == ButtonType.primary ? TextDecoration.underline : null;

    if (currentTextStyle == null) {
      return TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        decoration: decoration,
      );
    }
    if (currentTextStyle.decoration == null) {
      return currentTextStyle.copyWith(decoration: decoration);
    }
    return currentTextStyle;
  }

  Color _color(BuildContext context) {
    final colorTheme = context.colorTheme;
    if (buttonState == ButtonState.active) {
      return buttonType == ButtonType.primary
          ? colorTheme.primary11Reverse
          : colorTheme.primary13Reverse;
    }
    return buttonType == ButtonType.secondary
        ? colorTheme.basic7Reverse
        : colorTheme.primary9Reverse;
  }

  @override
  Widget build(BuildContext context) {
    return _AppLinkButton(
      isFillParent: isFillParent,
      disabled: buttonState.isDisabled,
      borderRadius: borderRadius,
      onPressed: onPressed,
      color: _color(context),
      leftIcon: leftIcon,
      buttonToIconSpace: buttonToIconSpace,
      padding: padding ?? buttonSize.padding,
      rightIcon: rightIcon,
      autoBalanceIcon: autoBalanceIcon,
      textStyle: _overridedTextStyle(context),
      text: text,
    );
  }
}

class _AppLinkButton extends StatelessWidget {
  final double? borderRadius;
  final bool isFillParent;
  final bool disabled;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final Widget? leftIcon;
  final Color? color;
  final Widget? rightIcon;
  final String text;
  final TextStyle? textStyle;
  final double buttonToIconSpace;
  final bool autoBalanceIcon;

  const _AppLinkButton({
    this.borderRadius,
    required this.isFillParent,
    required this.disabled,
    this.onPressed,
    this.padding,
    this.color,
    this.leftIcon,
    this.autoBalanceIcon = false,
    this.rightIcon,
    this.buttonToIconSpace = 24,
    required this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return _ButtonWrapper(
      isFillParent: isFillParent,
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: padding ?? EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
          ),
          foregroundColor: color,
        ),
        onPressed: disabled ? null : onPressed,
        child: _ButtonContent(
          childUseFlex: isFillParent,
          text: text,
          buttonToIconSpace: buttonToIconSpace,
          leftIcon: leftIcon,
          rightIcon: rightIcon,
          textStyle: textStyle,
          autoBalanceIcon: autoBalanceIcon,
        ),
      ),
    );
  }
}
