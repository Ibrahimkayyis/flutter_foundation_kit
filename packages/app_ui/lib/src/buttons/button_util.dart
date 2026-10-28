part of 'button.dart';

class ButtonUtil {
  static Color getColor(ButtonType buttonType, BuildContext context) {
    switch (buttonType) {
      case ButtonType.primary:
        return context.colorTheme.primary11Reverse;
      case ButtonType.secondary:
        return context.colorTheme.accent10Reverse;
    }
  }
}
