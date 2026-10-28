part of 'radio.dart';

class AppRadioButtonField<T> extends StatefulWidget {
  final String? title;
  final List<RadioModel<T>> options;
  final T? initialValue;
  final FormFieldValidator<T>? validator;
  final ValueChanged<T?>? onChanged;
  final FormFieldSetter<T>? onSaved;
  final LabelPosition labelPosition;

  const AppRadioButtonField({
    super.key,
    this.title,
    required this.options,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.labelPosition = LabelPosition.right,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AppRadioButtonFieldState<T> createState() => _AppRadioButtonFieldState<T>();
}

class _AppRadioButtonFieldState<T> extends State<AppRadioButtonField<T>> {
  T? _selectedOption;

  @override
  void initState() {
    _selectedOption = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: _selectedOption,
      validator: widget.validator,
      onSaved: widget.onSaved,
      builder: (FormFieldState<T> field) {
        final List<Widget> radioButtons = [];

        for (var i = 0; i < widget.options.length; i++) {
          radioButtons.add(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.labelPosition == LabelPosition.left &&
                    widget.options[i].label != null)
                  Wrap(children: [Text(widget.options[i].label!)]),
                Radio<T>(
                  value: widget.options[i].value,
                  groupValue: field.value,
                  activeColor: context.colorTheme.primary10Reverse,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                      field.didChange(value);
                      if (widget.onChanged != null) {
                        widget.onChanged!(value);
                      }
                    });
                  },
                ),
                if (widget.labelPosition == LabelPosition.right &&
                    widget.options[i].label != null)
                  Wrap(children: [Text(widget.options[i].label!)]),
                const SizedBox(width: 16),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.title ?? ''),
            Wrap(children: [...radioButtons]),
            if (field.errorText != null)
              Text(
                field.errorText!,
                style: TextStyle(color: context.colorTheme.accent12Reverse),
              ),
          ],
        );
      },
    );
  }
}

class RadioModel<T> {
  final String? label;
  final T value;

  RadioModel({required this.label, required this.value});
}
