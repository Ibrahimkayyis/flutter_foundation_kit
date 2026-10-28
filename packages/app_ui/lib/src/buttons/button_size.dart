part of 'button.dart';

enum ButtonSize {
  large(EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
  defaultSize(EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
  small(EdgeInsets.symmetric(vertical: 6, horizontal: 16)),
  noPadding(EdgeInsets.zero);

  const ButtonSize(this.padding);
  final EdgeInsets padding;
}
