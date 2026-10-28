part of 'button.dart';

class AppRoundedButton extends AppButton {
  const AppRoundedButton({
    super.key,
    required super.text,
    super.leftIcon,
    super.rightIcon,
    super.buttonState,
    super.borderRadius = 32.0,
    super.isFillParent,
    super.buttonSize,
    super.buttonType,
    required super.onPressed,
    super.textStyle,
    super.autoBalanceIcon,
    super.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppDefaultButton(
      text: text,
      leftIcon: leftIcon,
      rightIcon: rightIcon,
      borderRadius: borderRadius,
      isFillParent: isFillParent,
      buttonSize: buttonSize,
      buttonType: buttonType,
      buttonState: buttonState,
      onPressed: onPressed,
      textStyle: textStyle,
      padding: padding,
      autoBalanceIcon: autoBalanceIcon,
      buttonToIconSpace: buttonToIconSpace,
    );
  }
}
