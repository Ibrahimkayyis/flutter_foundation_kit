import 'package:flutter/material.dart';
import 'package:app_ui/nti_ui.dart';

part 'default_button.dart';
part 'link_button.dart';
part 'outlined_button.dart';
part 'rounded_button.dart';
part 'button_state.dart';
part 'rounded_outlined_button.dart';
part 'button_size.dart';
part 'button_util.dart';
part 'button_type.dart';

abstract class AppButton extends StatelessWidget {
  final String text;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final double borderRadius;
  final bool isFillParent;
  final ButtonSize buttonSize;
  final ButtonType buttonType;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final double buttonToIconSpace;
  final ButtonState buttonState;
  final bool autoBalanceIcon;
  final double? elevation;

  const AppButton({
    super.key,
    required this.text,
    this.leftIcon,
    this.rightIcon,
    this.buttonState = ButtonState.enable,
    required this.borderRadius,
    this.isFillParent = false,
    this.buttonSize = ButtonSize.defaultSize,
    this.buttonType = ButtonType.primary,
    required this.onPressed,
    this.textStyle,
    this.elevation,
    this.padding,
    this.buttonToIconSpace = 24,
    this.autoBalanceIcon = false,
  });
}

class _ButtonWrapper extends StatelessWidget {
  final Widget child;
  final bool isFillParent;
  const _ButtonWrapper({required this.child, required this.isFillParent});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: isFillParent ? MainAxisSize.max : MainAxisSize.min,
      children: [Expanded(flex: isFillParent ? 1 : 0, child: child)],
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final Widget? leftIcon;
  final Widget? rightIcon;
  final String text;
  final TextStyle? textStyle;
  final double buttonToIconSpace;
  final bool autoBalanceIcon;
  final bool childUseFlex;

  const _ButtonContent({
    this.leftIcon,
    this.rightIcon,
    required this.childUseFlex,
    required this.text,
    this.textStyle,
    required this.buttonToIconSpace,
    this.autoBalanceIcon = false,
  });

  Widget? _buildIcon({Widget? realIcon, Widget? oppositeIcon}) {
    if (!autoBalanceIcon) return realIcon;
    if (realIcon != null) return realIcon;
    if (oppositeIcon == null) return null;
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: false,
      child: oppositeIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasIcon = leftIcon != null || rightIcon != null;
    final finalLeftIcon = _buildIcon(
      realIcon: leftIcon,
      oppositeIcon: rightIcon,
    );
    final finalRightIcon = _buildIcon(
      realIcon: rightIcon,
      oppositeIcon: leftIcon,
    );
    final textWidget = Text(
      text,
      style: textStyle,
      textAlign: TextAlign.center,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          hasIcon && autoBalanceIcon
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
      children: [
        if (finalLeftIcon != null) finalLeftIcon,
        if (hasIcon && autoBalanceIcon) SizedBox(width: buttonToIconSpace),
        childUseFlex ? Flexible(child: textWidget) : textWidget,
        if (hasIcon && autoBalanceIcon) SizedBox(width: buttonToIconSpace),
        if (finalRightIcon != null) finalRightIcon,
      ],
    );
  }
}


typedef NTIButton = AppButton;
typedef NTIDefaultButton = AppDefaultButton;
typedef NTIOutlinedButton = AppOutlinedButton;
typedef NTIRoundedButton = AppRoundedButton;
typedef NTILinkButton = AppLinkButton;
typedef NTIRoundedOutlinedButton = AppRoundedOutlinedButton;
