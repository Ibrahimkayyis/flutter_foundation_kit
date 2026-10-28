part of 'button.dart';

class AppRoundedOutlinedButton extends AppButton {
  final bool forceOnPressed;
  const AppRoundedOutlinedButton({
    super.key,
    required super.text,
    super.leftIcon,
    super.rightIcon,
    super.borderRadius = 32.0,
    super.isFillParent,
    super.buttonSize,
    super.buttonType,
    this.forceOnPressed = false,
    super.buttonState,
    required super.onPressed,
    super.textStyle,
    super.autoBalanceIcon,
    super.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppOutlinedButton(
      text: text,
      leftIcon: leftIcon,
      rightIcon: rightIcon,
      borderRadius: borderRadius,
      isFillParent: isFillParent,
      buttonSize: buttonSize,
      buttonType: buttonType,
      onPressed: onPressed,
      forceOnPress: forceOnPressed,
      textStyle: textStyle,
      padding: padding,
      autoBalanceIcon: autoBalanceIcon,
      buttonState: buttonState,
      buttonToIconSpace: buttonToIconSpace,
    );
  }
}
