import 'package:flutter/material.dart';
import 'package:app_ui/src/style/styles.dart';

enum Position { left, right }

class AppCheckbox extends StatefulWidget {
  final Position labelPosition;
  final String? label;
  final ValueChanged<bool>? onChanged;
  final EdgeInsets padding;
  final bool initialValue;
  final bool? value;
  final FormFieldSetter<bool>? onSaved;

  const AppCheckbox({
    super.key,
    this.onChanged,
    this.labelPosition = Position.right,
    this.label,
    this.value,
    this.padding = const EdgeInsets.all(8.0),
    this.onSaved,
    this.initialValue = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AppCheckboxState createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      builder:
          (FormFieldState<bool> state) => InkWell(
            onTap: () {
              setState(() {
                state.didChange(!state.value!);
              });
              widget.onChanged?.call(state.value!);
            },
            child: Padding(
              padding: widget.padding,
              child: Row(
                children:
                    widget.labelPosition == Position.left
                        ? <Widget>[
                          Text(
                            widget.label ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                          widget.label != null
                              ? const SizedBox(width: 16)
                              : const SizedBox(width: 0),
                          Checkbox(
                            activeColor: context.colorTheme.brandTeal10Reverse,
                            visualDensity: VisualDensity.compact,
                            side: WidgetStateBorderSide.resolveWith(
                              (states) => const BorderSide(
                                width: 1.0,
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            value: state.value,
                            onChanged: (value) {
                              setState(() {
                                state.didChange(value);
                              });
                              widget.onChanged?.call(value ?? false);
                            },
                          ),
                        ]
                        : <Widget>[
                          Checkbox(
                            visualDensity: VisualDensity.compact,
                            activeColor: context.colorTheme.brandTeal10Reverse,
                            side: WidgetStateBorderSide.resolveWith(
                              (states) => const BorderSide(
                                width: 1.0,
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            value: state.value,
                            onChanged: (value) {
                              setState(() {
                                state.didChange(value);
                              });
                              widget.onChanged?.call(value ?? false);
                            },
                          ),
                          widget.label != null
                              ? const SizedBox(width: 16)
                              : const SizedBox(width: 0),
                          Text(
                            widget.label ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
              ),
            ),
          ),
    );
  }
}


typedef NTICheckbox = AppCheckbox;
