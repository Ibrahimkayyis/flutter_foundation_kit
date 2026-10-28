import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_ui/src/icon/nti_icon/icon.dart';
import 'package:app_ui/src/style/styles.dart';

class AppTextField extends StatefulWidget {
  final String? title;
  final String? initialValue;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixWidget;
  final AppIcons? suffixIcon;
  final FocusNode? focusNode;
  final bool enabled;
  final TextAlign? align;
  final bool obscureText;
  final EdgeInsets? padding;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final TextStyle? labelStyle;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final String? prefixText;
  final String? suffixText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? errorMaxLines;
  final int? minLines;
  final Iterable<String>? autofillHints;

  const AppTextField({
    super.key,
    this.title,
    this.padding,
    this.suffixIcon,
    this.align,
    this.initialValue,
    this.errorMaxLines,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixWidget,
    this.enabled = true,
    this.obscureText = false,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.readOnly = false,
    this.textInputAction,
    this.onTap,
    this.onFieldSubmitted,
    this.labelStyle,
    this.style,
    this.focusNode,
    this.hintStyle,
    this.keyboardType,
    this.prefixText,
    this.suffixText,
    this.inputFormatters,
    this.maxLines,
    this.minLines,
    this.autofillHints,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  bool _isFocus = false;
  bool _isError = false;

  Color getFillColor(BuildContext ctx) {
    if (!widget.enabled) return context.colorTheme.basic4Reverse;

    if (_isFocus || _isError || _controller.text.isNotEmpty) {
      return Colors.transparent;
    }
    return context.colorTheme.basic4Reverse;
  }

  @override
  void initState() {
    // debug print removed
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // debug print removed
    if (widget.controller == null) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, __, ___) {
                return TextFormField(
                  textAlign: widget.align ?? TextAlign.left,
                  autofillHints: widget.autofillHints,
                  controller: _controller,
                  onChanged: widget.onChanged,
                  obscureText: widget.obscureText,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  onSaved: widget.onSaved,
                  onTap: widget.onTap,
                  readOnly: widget.readOnly,
                  textInputAction: widget.textInputAction,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  validator: (value) {
                    final error = widget.validator?.call(value);
                    setState(() {
                      _isError = error != null;
                    });
                    return error;
                  },
                  style:
                      widget.style ??
                      TextStyle(
                        fontSize: 16,
                        color: context.colorTheme.basic10Reverse,
                      ),
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  decoration: AppInputDecoration.inputDecoration(
                    context,
                    prefixIcon: widget.prefixIcon,
                    suffixIcon:
                        widget.suffixWidget ??
                        (widget.suffixIcon != null
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppIcon(widget.suffixIcon!, height: 18),
                              ],
                            )
                            : null),
                    prefixStyle:
                        widget.style ??
                        TextStyle(
                          fontSize: 16,
                          color: context.colorTheme.basic7Reverse,
                        ),
                    hintText: widget.hintText,
                    hintStyle: widget.hintStyle,
                    errorMaxLines: widget.errorMaxLines,
                    fillColor: getFillColor(context),
                    prefixText: widget.prefixText,
                    padding:
                        (widget.padding) ??
                        (widget.title == null
                            ? const EdgeInsets.fromLTRB(16, 20, 16, 20)
                            : const EdgeInsets.fromLTRB(16, 30, 16, 10)),
                    suffixText: widget.suffixText,
                    enabled: widget.enabled,
                    isFilled: true,
                  ),
                );
              },
            ),
            Positioned(
              top: 10,
              left: widget.prefixIcon == null ? 16 : 48,
              child: Text(
                widget.title ?? '',
                style:
                    widget.labelStyle ??
                    TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: context.colorTheme.basic7Reverse,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NTIPasswordField extends StatefulWidget {
  final String? title;
  final String? initialValue;
  final bool isFilled;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  const NTIPasswordField({
    super.key,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.title,
    this.isFilled = false,
  });

  @override
  State<NTIPasswordField> createState() => _NTIPasswordFieldState();
}

class _NTIPasswordFieldState extends State<NTIPasswordField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      title: widget.title,
      enabled: true,
      maxLines: 1,
      initialValue: widget.initialValue,
      obscureText: !passwordVisible,
      suffixWidget: GestureDetector(
        onTap: () {
          setState(() {
            passwordVisible = !passwordVisible;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            passwordVisible
                ? const AppIcon(AppIcons.eyeOpen, height: 18)
                : const AppIcon(AppIcons.eyeClosed, height: 18),
          ],
        ),
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}


typedef NTITextField = AppTextField;
