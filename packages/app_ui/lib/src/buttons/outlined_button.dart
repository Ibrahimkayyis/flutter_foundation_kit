part of 'button.dart';

class AppOutlinedButton extends AppButton {
  final bool forceOnPress;
  const AppOutlinedButton({
    super.key,
    required super.text,
    super.borderRadius = 4,
    super.buttonState,
    super.leftIcon,
    super.rightIcon,
    super.isFillParent,
    super.buttonSize,
    this.forceOnPress = false,
    super.buttonType,
    super.onPressed,
    super.textStyle,
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
                ? colorTheme.basic5Reverse
                : _textColor(context),
      );
    }
    if (currentTextStyle.color == null) {
      return currentTextStyle.copyWith(
        color:
            buttonState.isDisabled
                ? colorTheme.basic6Reverse
                : _textColor(context),
      );
    }
    return currentTextStyle;
  }

  Color _textColor(BuildContext context) {
    if (buttonType == ButtonType.secondary) {
      if (buttonState == ButtonState.active) {
        return context.colorTheme.basic11Reverse;
      }
      return context.colorTheme.basic7Reverse;
    }
    if (buttonState == ButtonState.active) {
      return context.colorTheme.primary13Reverse;
    }
    return context.colorTheme.primary11Reverse;
  }

  Color _outlineColor(BuildContext context) {
    if (buttonType == ButtonType.secondary) {
      if (buttonState == ButtonState.active) {
        return context.colorTheme.basic11Reverse;
      }
      return context.colorTheme.basic7Reverse;
    }
    if (buttonState == ButtonState.active) {
      return context.colorTheme.primary13Reverse;
    }
    return context.colorTheme.primary11Reverse;
  }

  @override
  Widget build(BuildContext context) {
    return NTIBaseOutlineButton(
      onPressed: onPressed,
      text: text,
      padding: padding ?? buttonSize.padding,
      disabled: buttonState.isDisabled,
      forceOnPress: forceOnPress,
      disableBackgroundColor: context.colorTheme.basic1Reverse,
      borderRadius: borderRadius,
      disableBorderColor: context.colorTheme.basic5Reverse,
      borderColor: _outlineColor(context),
      isFillParent: isFillParent,
      textStyle: _overridedTextStyle(context),
      leftIcon: leftIcon,
      rightIcon: rightIcon,
      autoBalanceIcon: autoBalanceIcon,
    );
  }
}

class NTIBaseOutlineButton extends StatelessWidget {
  final double? borderRadius;
  final bool isFillParent;
  final bool disabled;
  final Color? backgroundColor;
  final Color borderColor;
  final Color disableBorderColor;
  final Color? disableBackgroundColor;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final String text;
  final double buttonToIconSpace;
  final bool autoBalanceIcon;
  final TextStyle? textStyle;
  final bool forceOnPress;
  const NTIBaseOutlineButton({
    super.key,
    this.borderRadius,
    this.isFillParent = false,
    this.backgroundColor,
    this.disableBorderColor = Colors.grey,
    this.disableBackgroundColor,
    this.onPressed,
    this.disabled = false,
    this.padding,
    this.leftIcon,
    this.buttonToIconSpace = 24,
    this.borderColor = Colors.blue,
    this.rightIcon,
    required this.text,
    this.textStyle,
    this.autoBalanceIcon = false,
    this.forceOnPress = true,
  });

  @override
  Widget build(BuildContext context) {
    return _ButtonWrapper(
      isFillParent: isFillParent,
      child: OutlinedButton(
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          foregroundColor: disabled ? disableBorderColor : borderColor,
          side: BorderSide(color: disabled ? disableBorderColor : borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
          ),
          backgroundColor: backgroundColor,
          disabledBackgroundColor: disableBackgroundColor,
          padding: padding ?? EdgeInsets.zero,
        ),
        onPressed: forceOnPress ? onPressed : (disabled ? null : onPressed),
        child: _ButtonContent(
          childUseFlex: isFillParent,
          buttonToIconSpace: buttonToIconSpace,
          text: text,
          leftIcon: leftIcon,
          rightIcon: rightIcon,
          textStyle: textStyle,
          autoBalanceIcon: autoBalanceIcon,
        ),
      ),
    );
  }
}
