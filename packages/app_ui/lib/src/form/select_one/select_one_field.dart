import 'package:flutter/material.dart';
import 'package:app_ui/src/form/radio/radio.dart';
import 'package:app_ui/src/style/styles.dart';

class IUSingleSelectField<T> extends StatefulWidget {
  final List<T> choices;
  final String Function(T data)? itemAsString;
  final T? initialValue;
  final CUSingleSelectFieldController<T>? controller;
  final String? title;
  final String? hintText;
  final String? desc;
  final String? Function(T?)? validator;
  final TextInputType? inputType;
  final int minLine;
  final int maxLine;
  final bool readOnly;
  final bool filled;
  final void Function(T? value)? onChange;
  final Color? backgroundColor;
  final Function(T? value)? onSaved;
  final TextInputAction? textInputAction;
  final EdgeInsets? contentPadding;
  final bool? enabled;
  final FocusNode? focusNode;
  final bool? autofocus;
  final BorderRadius borderRadius;
  final double row;
  final WrapAlignment? alignment;
  final double? runSpacing;
  final Widget Function(List<Widget> items)? buildLayout;

  IUSingleSelectField({
    super.key,
    this.onChange,
    required this.choices,
    this.controller,
    this.hintText,
    this.focusNode,
    this.minLine = 1,
    this.autofocus,
    this.maxLine = 1,
    this.title,
    this.enabled,
    this.validator,
    this.inputType,
    this.row = 2,
    this.desc,
    this.readOnly = false,
    this.backgroundColor,
    this.filled = false,
    this.onSaved,
    this.textInputAction,
    this.contentPadding,
    this.initialValue,
    this.itemAsString,
    this.buildLayout,
    this.alignment,
    this.runSpacing,
  }) : borderRadius = BorderRadius.circular(8);

  @override
  State<IUSingleSelectField<T>> createState() => _IUSingleSelectFieldState<T>();
}

class CUSingleSelectFieldController<T> extends ValueNotifier<T?> {
  CUSingleSelectFieldController({T? initialValue}) : super(initialValue);
}

class _IUSingleSelectFieldState<T> extends State<IUSingleSelectField<T>> {
  late CUSingleSelectFieldController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        CUSingleSelectFieldController(initialValue: widget.initialValue);
    _controller.addListener(_onValueChange);
  }

  void _onValueChange() {
    setState(() {});
    widget.onChange?.call(_controller.value);
  }

  void _onItemTap(T value) {
    _controller.value = value;
  }

  List<Widget> buildChildren(BuildContext context) {
    return widget.choices
        .map(
          (e) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NTIAlternativeRadioButton(
                isActive: e == _controller.value,
                onChange: (_) => _onItemTap(e),
              ),
              const SizedBox(width: 16),
              Text(
                widget.itemAsString?.call(e) ?? e.toString(),
                style: context.text.sm.medium.applyColor(
                  context.colorTheme.basic11Reverse,
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller?.removeListener(_onValueChange);
    } else {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FormField(
        onSaved: (_) => widget.onSaved?.call(_controller.value),
        builder: (field) {
          final child =
              widget.buildLayout?.call(buildChildren(context)) ??
              Wrap(
                alignment: widget.alignment ?? WrapAlignment.spaceEvenly,
                runAlignment: WrapAlignment.spaceEvenly,
                runSpacing: widget.runSpacing ?? 0,
                children:
                    widget.choices
                        .map(
                          (e) => LayoutBuilder(
                            builder: (context, constraints) {
                              final maxWidth =
                                  constraints.maxWidth / widget.row;
                              return SizedBox(
                                width: maxWidth,
                                child: InkWell(
                                  onTap: () => _onItemTap(e),
                                  child: Row(
                                    children: [
                                      NTIAlternativeRadioButton(
                                        isActive: e == _controller.value,
                                        onChange: (_) => _onItemTap(e),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          widget.itemAsString?.call(e) ??
                                              e.toString(),
                                          style: context.text.sm.medium
                                              .applyColor(
                                                context
                                                    .colorTheme
                                                    .basic11Reverse,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
              );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.title!,
                    style: context.text.xs.applyColor(
                      context.colorTheme.basic7Reverse,
                    ),
                  ),
                ),
              child,
            ],
          );
        },
      ),
    );
  }
}
