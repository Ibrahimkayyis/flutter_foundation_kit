part of 'button.dart';

class AppDefaultButton extends AppButton {
  const AppDefaultButton({
    super.key,
    required super.text,
    super.buttonState,
    super.leftIcon,
    super.rightIcon,
    super.borderRadius = 4,
    super.isFillParent,
    super.buttonSize,
    super.buttonType,
    required super.onPressed,
    super.textStyle,
    super.elevation,
    super.buttonToIconSpace,
    super.autoBalanceIcon,
    super.padding,
  });

  TextStyle _overridedTextStyle(BuildContext context) {
    final colorTheme = context.colorTheme;
    final currentTextStyle = textStyle;

    if (currentTextStyle == null) {
      return context.text.base.bold.copyWith(
        color:
            buttonState.isDisabled
                ? colorTheme.basic6Reverse
                : colorTheme.basic1Reverse,
      );
    }
    if (currentTextStyle.color == null) {
      return currentTextStyle.copyWith(
        color:
            buttonState.isDisabled
                ? colorTheme.basic6Reverse
                : colorTheme.basic1Reverse,
      );
    }
    return currentTextStyle;
  }

  Color _backgroundColor(BuildContext context) {
    if (buttonType == ButtonType.primary) {
      return context.colorTheme.primary11Reverse;
    }
    return context.colorTheme.brandAccent10Reverse;
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme;
    if (buttonState == ButtonState.active) {
      return NTIBaseOutlineButton(
        text: text,
        onPressed: onPressed,
        borderRadius: borderRadius,
        borderColor:
            buttonType == ButtonType.primary
                ? colorTheme.primary11Reverse
                : colorTheme.accent10Reverse,
        leftIcon: leftIcon,
        autoBalanceIcon: autoBalanceIcon,
        rightIcon: rightIcon,
        padding: padding ?? buttonSize.padding,
        isFillParent: isFillParent,
      );
    }
    if (buttonState == ButtonState.disable &&
        buttonType == ButtonType.secondary) {
      return NTIBaseOutlineButton(
        text: text,
        onPressed: onPressed,
        leftIcon: leftIcon,
        rightIcon: rightIcon,
        isFillParent: isFillParent,
        disabled: true,
        autoBalanceIcon: autoBalanceIcon,
        padding: padding ?? buttonSize.padding,
        borderRadius: borderRadius,
      );
    }
    return NTIBaseDefaultButton(
      text: text,
      onPressed: onPressed,
      disabled: buttonState.isDisabled,
      backgroundColor: _backgroundColor(context),
      borderRadius: borderRadius,
      isFillParent: isFillParent,
      padding: padding ?? buttonSize.padding,
      disableBackgroundColor: colorTheme.basic4Reverse,
      leftIcon: leftIcon,
      autoBalanceIcon: autoBalanceIcon,
      rightIcon: rightIcon,
      elevation: elevation,
      buttonToIconSpace: buttonToIconSpace,
      textStyle: _overridedTextStyle(context),
    );
  }
}

class NTIBaseDefaultButton extends StatelessWidget {
  final double? borderRadius;
  final bool isFillParent;
  final bool disabled;
  final Color? backgroundColor;
  final Color? disableBackgroundColor;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final String text;
  final double buttonToIconSpace;
  final TextStyle? textStyle;
  final double? elevation;
  final bool autoBalanceIcon;
  const NTIBaseDefaultButton({
    super.key,
    this.borderRadius,
    this.isFillParent = false,
    this.backgroundColor,
    this.disableBackgroundColor,
    this.onPressed,
    this.disabled = false,
    this.elevation,
    this.padding,
    this.leftIcon,
    this.rightIcon,
    required this.text,
    this.textStyle,
    this.buttonToIconSpace = 24,
    this.autoBalanceIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return _ButtonWrapper(
      isFillParent: isFillParent,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          elevation: elevation,
          padding: padding ?? EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius != null
                    ? BorderRadius.circular(borderRadius!)
                    : BorderRadius.zero,
          ),
          disabledBackgroundColor: disableBackgroundColor,
          backgroundColor: backgroundColor,
        ),
        onPressed: !disabled ? onPressed : null,
        child: _ButtonContent(
          buttonToIconSpace: buttonToIconSpace,
          text: text,
          childUseFlex: isFillParent,
          leftIcon: leftIcon,
          rightIcon: rightIcon,
          textStyle: textStyle,
          autoBalanceIcon: autoBalanceIcon,
        ),
      ),
    );
  }
}
