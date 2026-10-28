import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_ui/src/icon/index.dart';
import 'package:app_ui/src/layout/index.dart';
import 'package:app_ui/src/rich_text/embeded/image/embeded_image.dart';
import 'package:app_ui/src/rich_text/embeded/table/embeded_table.dart';
import 'package:app_ui/src/style/styles.dart';
import 'package:app_types/types.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:flutter_quill/flutter_quill.dart'
    show FlutterQuillLocalizations;

part 'dialog.dart';
part 'toolbar.dart';
part 'rich_text_preview.dart';
part 'inline.dart';
part 'rich_text_view.dart';

class NTIRichTextFieldParams {
  final bool showImagePicker;

  const NTIRichTextFieldParams({this.showImagePicker = true});
}

class NTIRichTextEmbededBuilder {
  static builder() => [NTIImageEmbedBuilder(), EmbededTableBuilder()];
}

class NTIRichTextField extends StatefulWidget {
  final double height;
  final NTIRichText? initial;
  final String? hint;
  final NTIRichTextFieldParams params;
  final String? title;
  final String? Function(NTIRichText? value)? validator;
  final void Function(NTIRichText? value)? onSaved;
  const NTIRichTextField({
    super.key,
    this.height = 84,
    this.initial,
    this.hint,
    this.title,
    this.validator,
    this.params = const NTIRichTextFieldParams(),
    this.onSaved,
  });

  @override
  State<NTIRichTextField> createState() => _NTIRichTextFieldState();
}

class _NTIRichTextFieldState extends State<NTIRichTextField> {
  late quill.QuillController _controller;

  @override
  void initState() {
    super.initState();

    _controller = quill.QuillController(
      document:
          widget.initial?.let((value) => quill.Document.fromJson(value.json)) ??
          quill.Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void _startEdit() async {
    final result = await NTIRichTextFullScreen.launch(
      context,
      _controller.document.toDelta(),
      params: widget.params,
      hint: widget.hint,
      title: widget.title,
    );
    if (result == null) return;

    _controller = quill.QuillController(
      document: result,
      selection: const TextSelection.collapsed(offset: 0),
    );

    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    final text = context.text;
    return FormField(
      onSaved: (_) {
        widget.onSaved?.call(
          _controller.document.let((value) {
            return !value.isEmpty()
                ? NTIRichText(json: value.toDelta().toJson())
                : null;
          }),
        );
      },
      validator:
          (_) => widget.validator?.call(
            _controller.document.let((value) {
              return !value.isEmpty()
                  ? NTIRichText(json: value.toDelta().toJson())
                  : null;
            }),
          ),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _startEdit,
              child: AbsorbPointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: color.basic12,
                    border: Border.all(
                      color:
                          field.hasError
                              ? color.accent12Reverse
                              : color.basic5Reverse,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  height: widget.height,
                  child: _FadedEdges(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.title != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              widget.title!,
                              style: text.xs.copyWith(
                                color: color.basic8Reverse,
                              ),
                            ),
                          ),
                        Expanded(
                          child: SingleChildScrollView(
                            child:
                                _controller.document.isEmpty()
                                    ? Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        widget.hint ?? "",
                                        style: text.base.copyWith(
                                          color: color.basic7,
                                        ),
                                      ),
                                    )
                                    : Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: quill.QuillEditor.basic(
                                        controller: _controller,

                                        config: quill.QuillEditorConfig(
                                          autoFocus: false,

                                          embedBuilders:
                                              NTIRichTextEmbededBuilder.builder(),
                                        ),
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 12),
                child: Text(
                  field.errorText!,
                  style: context.text.xs.applyColor(color.accent12),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _FadedEdges extends StatelessWidget {
  const _FadedEdges({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstOut,
      shaderCallback:
          (Rect rect) => LinearGradient(
            colors: [
              Colors.transparent,
              context.colorTheme.basic9Reverse.withAlpha((.85 * 255).round()),
            ],
            stops: const [0.85, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(rect),
      child: child,
    );
  }
}

extension _DynamicExt<T extends dynamic> on T {
  Y let<Y>(Y Function(T value) fun) => fun(this);
}
