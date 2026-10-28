import 'package:flutter/material.dart';
import 'package:app_ui/src/style/styles.dart';

part 'radio_form_field.dart';
part 'label_position.dart';

class AppRadioButton extends StatefulWidget {
  final String? label;
  final String value;
  final String groupValue;
  final LabelPosition labelPosition;
  final ValueChanged<String> onChanged;

  const AppRadioButton({
    super.key,
    this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.labelPosition = LabelPosition.right,
  });

  @override
  State<AppRadioButton> createState() => _AppRadioButtonState();
}

class _AppRadioButtonState extends State<AppRadioButton> {
  @override
  Widget build(BuildContext context) {
    bool selected = (widget.value == widget.groupValue);

    return Row(
      children: [
        if (widget.labelPosition == LabelPosition.left && widget.label != null)
          Wrap(children: [Text(widget.label!), const SizedBox(width: 16)]),
        InkWell(
          customBorder: const CircleBorder(),
          onTap: () => widget.onChanged(widget.value),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    selected
                        ? context.colorTheme.brandTeal10Reverse
                        : const Color(0xffD9D9D9),
              ),
              color:
                  selected
                      ? context.colorTheme.primary6Reverse
                      : Colors.transparent,
            ),
            child: Icon(
              Icons.circle,
              size: 14,
              color:
                  selected
                      ? context.colorTheme.brandTeal10Reverse
                      : Colors.transparent,
            ),
          ),
        ),
        if (widget.labelPosition == LabelPosition.right && widget.label != null)
          Wrap(children: [const SizedBox(width: 16), Text(widget.label!)]),
      ],
    );
  }
}

class NTIAlternativeRadioButton extends StatelessWidget {
  final bool isActive;
  final Color? activeColor;
  final Color? inActiveColor;
  final void Function(bool isActive)? onChange;
  const NTIAlternativeRadioButton({
    super.key,
    this.isActive = false,
    this.activeColor,
    this.inActiveColor,
    this.onChange,
  });

  Color activeColorBuilder(BuildContext context) =>
      activeColor ?? context.colorTheme.primary11Reverse;

  Color inActiveColorBuilder(BuildContext context) =>
      inActiveColor ?? context.colorTheme.basic5Reverse;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChange?.call(isActive),
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 2,
            color:
                isActive
                    ? activeColorBuilder(context)
                    : inActiveColorBuilder(context),
          ),
        ),
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeColorBuilder(context) : null,
          ),
        ),
      ),
    );
  }
}


typedef AppRadio = AppRadioButton;
typedef AppRadioFormField<T> = AppRadioButtonField<T>;
typedef NTIRadio = AppRadioButton;
typedef NTIRadioFormField<T> = AppRadioButtonField<T>;
typedef NTIRadioButton = AppRadioButton;
typedef NTIRadioButtonField<T> = AppRadioButtonField<T>;
