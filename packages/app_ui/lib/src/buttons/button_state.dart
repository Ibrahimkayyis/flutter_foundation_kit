part of 'button.dart';

enum ButtonState {
  enable,
  disable,
  active;

  const ButtonState();

  bool get isDisabled => this == ButtonState.disable;
}
